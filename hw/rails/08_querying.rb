# finder methods retrive data from the DB instead of SQL-type queries
    # some methods that return a collection of rows return an instance of ActiveRecord::Relation
    # methods that return a single row return an instance of that model

# retrieving a single object
Client.find(1)                  # find client with id 1                     // SELECT * FROM clients WHERE (client.id = 10) LIMIT 1
    Client.find([1, 10])        # find client with id of 1 or 10            // SELECT * FROM clients WHERE (client.id IN (1,10))

Client.take                     # takes first client no ordering            // SELECT * FROM clients LIMIT 1
    # returns nil if none found, does not raise exception
    Client.take(5)              # takes first 5 clients                     // SELECT * FROM clients LIMIT 2

Client.first                    # takes first client ordered by id          // SELECT * FROM clients ORDER BY clients.id ASC LIMIT 1
    Client.first(5)             # takes first 5 clients ordered by id       // SELECT * FROM clients ORDER BY clients.id ASC LIMIT 5
    Client.order(:name).first   # takes first client in that order          // SELECT * FROM clients ORDER BY clients.name ASC LIMIT 1
Client.last(n)                  # takes last n                              // SELECT * FROM clients ORDER BY clients.id DESC LIMIT n
    Client.last!                # raises if none found

Client.find_by name: 'bob'      # finds matching conditions                 // SELECT * FROM clients WHERE (clients.name = 'Bob') LIMIT 1
    Cilent.find_by!             # raises if not found

# retrieving multiple objects in batches
Client.all                      # returns all clients
    Client.all.each do |customer|       # can get ugly
    # instead rely on batches
Client.find_each                # retrieves a batch and returns each row individually
    Client.find_each do |client| 
    # raises warning if used on ordered collection as it needs to impose its own order
    Client.find_each(batch_size: 5000)  # set batch size
    Client.find_each(start: 2500)       # set starting id of the batch sequence
    Client.find_each(finish: 5000)      # set ending id of the batch sequence
        Client.find_each(start: 1, finish: 10)  # set batch to take ids 1 to 10
    Client.find_each(error_on_ignore: true)     # overrides config to raise exception if order by clause is found
Client.find_in_batches          # returns the batches of records themselves, rather than each row individually
    Client.find_in_batches do |clients| # clients is a collection
    # accepts same options as find_each

# conditions
Client.where("name = 'bob'")    # pure string condition, vulnerable to SQL injections if using parameters from the front-end
    Client.where("name = ?", params[:name])     # prepared query-style conditions, preferred
    Client.where("name = ? AND city = ?", params[:name], params[:city])
    Client.where("born_on >: some_date", { some_date: params[:date] })  # can be done using keys hash
    Client.where("name LIKE ?",
        Client.sanitize_sql_like(params[:name]) + "%")  # when using LIKE, need to enforce sanitization to prevent unpredictable results with wildcard characters % or _
# hash conditions forego strings entirely
Client.where(name: 'bob')       # where name = 'bob'
    Client.where('name' => 'bob')   # field name can be a string
    Client.where(company: company)  # if belongs_to and company is something like Company.take
    Client.where(born_on: (Time.now.midnight - 30.years)..(Time.now.midnight - 20.years))   # finds all clients that are between 20 and 30
    Client.where(born_on: (Time.now.midnight - 30.years)..)                                 # finds all clients that are under 30
    Client.where(city: ['Montreal', 'Sherbrooke', 'Gaspé']) # where IN (...)
    Client.where.not(city: ['Laval', 'Longueuil']) # where NOT IN

# OR
Client.where(name: 'bob').or(Client.where(name: 'jane'))

# AND
Client.where(name: 'bob').where(city: 'Montreal')

# order by
Client.order(:created_at)
    Client.order(:created_at :desc)
    Client.order('created_at')
    Client.order('created_at DESC')
    Client.order(:created_at :desc, name: :asc)

# select (specify fields)
Client.select(:name, :city)
    Client.select('name', 'city')
    Client.select(:city).distinct               # returns only rows with distinct values
Client.pluck(:name)                             # returns records as hashes instead of ActiveRecords

# limit
Client.limit(5).offset(10)                      # SELECT * FROM clients LIMIT 5 OFFSET 10

# group by
Client.select(:city).group(:city)
    Client.group(:city).count                   # SELECT COUNT(*) FROM clients GROUP BY city

# having (to specify conditions on the group by clause)
Client.group(:city).count.having(active: true)

# overriding conditions
Client.order('id desc').unscope(:order)         # removes the ORDER BY clause
    Client.where(id: 10, name: 'bob').unscope(where: :id)    # removes a speific WHERE clause
Client.order('id').where('id < ?', 10).only(:where)          # applies only the ORDER clause
Client.select(:name).reselect(:city)            # redefines the SELECT clause
    .reorder                                    # redefines the ORDER BY clause
    .reverse_order                              # reverse the ordering clause
    .rewhere                                    # redefines the WHERE clause

# Null relations
Client.none                                     # returns a chainable relation with no records

Client.readonly.all                             # returns read-only records, raises exception if they are modified

# locking - TBD, useful only when multiple users are doing DB stuff

# joins
Client.joins("INNER JOIN invoices ON invoice.client_id = client.id")  # string join
    Client.joins(:invoices)                     # using ActiveRecord Associations, uses INNER JOIN
    Client.joins(:invoices, :payments)          # multiple join
    Client.joins(invoices: :lines)              # nested join
    Client.joins(invoices: [{ lines: { article: :suppliers } }, :payment] ) # complex nested join
    Client.joins(:orders).where(delivered: true)# conditional join
Client.left_outer_joins(:invoices)              # uses LEFT OUTER JOIN instead

# associations can be eager loaded to prevent query repetition
clients = Client.includes(:contact)             # then can loop on clients without doing one new query per line
clients = Client.preload(:contact)              # then can loop on clients without doing one new query per line
    # unlike includes, preload doesn't accept conditional loading
clients = Client.eager_load(:contact)           # uses left outer join

# scopes specify commonly-used queries that can be refered as method calls on the association objects or models
    # all scope bodies should return an ActiveRecord::Relation or nil
class Client < ApplicationRecord
    scope :active, -> { where(active: true) }   # can then call Client.active
    scope :new_active, -> { active.where('created_dt > ?', :some_date) } 
        # can be referred by other scopes
    scope :big, ->(amount) { where('total_acconuts > ?', amount) }  # passing variables to the scope
        Client.big(100000) # calls clients with at least 100'000$ in total accounts
    scope :created_before, ->(timestamp) { where('created_dt < ?', tiemstamp) if timestamp.present? }
    
    # scopes always return an ActiveRelation::Record object
    default_scope { active }    # default scope applied to all queries to the model
        # default scopes also apply when creating the model
        Client.new              # active=true
        Client.unscoped.new     # active=nil
    Client.big.created_before   # merge clauses with AND
        # see https://guides.rubyonrails.org/active_record_querying.html#applying-a-default-scope for default scope shenanigans
end

# dynamic finders - for every field/attribute defined in the table
Citizen.find_by_name('bob')     # for attribute :name

# enums 
class Order > ApplicationRecord
    enum :status, [:shipped, :packaging, :complete, :cancelled]
    # creates scopes that can be used to find all objects that have or do not have one of the enum values
    # creates an instance method that can be used to determine if the object has a particular value for the enum
    # creates an instance method that can be used to change the enum value of the object
    Order.shipped           # collection of shipped orders
    Order.not_shipped       # collection of non-shipped orders
    order.shipped?          # is order shipped
end

# create obj if not found
Client.find_or_create_by(name: 'bob')       # finds client named bob, creates on with name bob if not found
Client.for_or_initialize_by(name: 'bob')    # finds client named bob, calls new instead of create if not found

Client.find_by_sql('SELECT * FROM clients') # custom SQL find
Client.connection.select_all('SELECT *')    # custom SQL but returns uninstanciated records as hashes

Client.ids                                  # returns the IDs only

Client.exists?(some_conditions)             # returns true/false
    # via a model
    Order.any?
    # => SELECT 1 FROM orders LIMIT 1
    Order.many?
    # => SELECT COUNT(*) FROM (SELECT 1 FROM orders LIMIT 2)

    # via a named scope
    Order.shipped.any?
    # => SELECT 1 FROM orders WHERE orders.status = 0 LIMIT 1
    Order.shipped.many?
    # => SELECT COUNT(*) FROM (SELECT 1 FROM orders WHERE orders.status = 0 LIMIT 2)

    # via a relation
    Book.where(out_of_print: true).any?
    Book.where(out_of_print: true).many?

    # via an association
    Customer.first.orders.any?
    Customer.first.orders.many?

# calculations
Client.count
Order.average('total')
Order.minimum('total')
Order.maximum('total')
Order.sum('total')

# use explain to show query
Client.where(id: 1).joins(:orders).explain
