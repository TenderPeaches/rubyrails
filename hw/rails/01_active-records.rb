# https://guides.rubyonrails.org/active_record_basics.html

# active records:
#   represent model & data
#   represent links between models
#   represent inheritence hierarchies between models
#   validate models before they get persisted
#   perform DB operations

# they are setup in a default way, with the assumption that it used most of the time

# naming conventions:
#   model class- singular with ThisCase
#   database table- plural with snake_case
#   primary keys- integer column `id`
#   foreign keys- `singularized_table_name_id`, like `item_id` for a fk to `items`

# optional columns added to records:
#   created_at- timestamp when record is created
#   updated_at- timestamp when record is updated
#   lock_version- optimistic locking

# to create active record models, inherit the ApplicationRecord class
class SomeModel < ApplicationRecord
    # this creates SomeModel model mapped to some_models table
    # to override default naming convention, see classes in ActiveRecord::Base
    self.table_name = "custom_table_name"           # must specify class name holding the fixtures in test functions, see set_fixture_class
    self.primary_key = "custom_pk"                  # cannot use `id` for non-primary key columns

    attr_accessor :name                           # specify list of model attributes that can be set with new(), update_attributes() or attributes=
end

# CRUD - see https://guides.rubyonrails.org/active_record_querying.html
# Create
user = User.create(name: "Jane", occupation: "Doe") # instantiate & save the object at once
user = User.new                                     # instantiate user without saving
user.name = "Jane"                                  # set instance properties
user.save                                           # save instance to DB
user = User.new do |u|                              # block initialization
    u.name = "Jane"
end
user.new_record?                                    # if model has not yet been saved to DB

user.errors.full_messages                           # if model fails to save or something, use this; rets array of messages

# Read
users = User.all                                    # select all
user = User.first                                   # return the first user
user = User.find_by(name: 'Jane')                   # return user with matching value
user = User.where(name: 'Jane', occupation: 'Doe')  # return user matching conditions
users = User.order(name: :desc)                     # return users ordered by

# Update
user.update(name: 'Lane')                           # user is loaded first
user.update_all "active = 1"                        # batch update

# Delete
user.destroy
User.destroy_by(name: 'Jane')
User.destroy_all                                    # truncate

# active records can validate the state of a model before applying DB modifications
# see https://guides.rubyonrails.org/active_record_validations.html
class User < ApplicationRecord
    validates :name, presence: true                 # name is required
end
User.create(name: 'bob').valid?                     # whether a model is valid
User.create(name: 'bob').invalid?                   # whether a model is invalid
# these validations can replaced DB-side validations, but DB-side validations are still useful if the DB is meant to be used for more apps than one
# client-side validations are unreliable on their own but are good for providing quick user feedback
# validations are run before saving to DB; if any fail, the commit doesn't happen for this ActiveRecord
# they are triggered by the methods: create, save, update; the ! versions trigger an exception when model is invalid
# some methods change the object but do not trigger validations: decrement, increment, insert, insert_all, toggle, touch, touch_all, update_all, update_attribute, update_column, update_columns, update_counters, upsert
# can also skip validations with model.save(validate: false)

print user.errors.objects.first.full_message        # if model is invalid, the validation errors will be found in model.errors and accessed
print user.errors[:name].any?                       # can target specific fields by accessing them through the errors array

# helpers
# validations use predefined helpers to use inside class definitions
# all validations accept :on and :message options
class User < ApplicationRecord
  validates :field, acceptance: true                # field must be checked; for terms of service, "do you agree", etc; check only performed if `field` is not nil
  validates :eula, acceptance: { accept: ['TRUE', 'yes', 'ok', 1]}  # can also receive :accept option to define acceptable values, defaults to ['1', true]
  
  validates_associated :records                     # if stuff like has_many :records, will also validate each record; (!) don't do mutual calls bc that creates inifinite calls
  
  validates :email, confirmation: true              # expects a field email_confirmation that should match email (unless email_confirmation is nuil)
  validates :email_confirmation, presence: true     # to require confirmation, use `presence`
  validates :email, confirmation: { case_sensitive: false } # case insensitive match

  validates :start_date, comparison: { greater_than: :end_date } # comparison operator, also supports :greater_than_or_equal, :equal_to, :less_than, :less_than_or_equal, :other_than
  
  validates :subdomain, exlusion: { in: %w(www us ca) } # value must not be in the given set
  validates :size, inclusion: { in: %w(sm md lg) }  # value must be in given set

  validates :code, format: { with: /[a-z]{9}/}      # validate against regexp

  validates :field, length: { minimum: 2 }          # validate field value length
  validates :field, length: { maximum: 100 }
  validates :field, length: { in 1..20 }
  validates :field, length: { is: 15 }

  validates :field, numericality: true              # value must be number
  validates :field, numericality: { only_integer: true } # value must be integer
  # numericality also accepts same options as :comparison, also :in, :odd and :even

  validates :field, presence: true                  # value must not be empty
  validates :field, absence: true                   # value must be empty

  validates :field, uniqueness: true                # value must be unique
  validates :field, uniqueness: { scope :year }     # value must be unique within scope
  # can also set :case_sensitive

  # can use custom validation classes
  class SomeValidator < AciveModel::Validator
    def validate(record)
      if some_condition == true 
        record.errors.add :base, "some error"
      end
    end
  end
  validates_with SomeValidator                      

  # common validation options
  :allow_nil                                        # skips validation when value is nil
  :allow_blank                                      # skips validation when value is blank?, such as nil or empty string
  :message                                          # specify the error message when the validation fails
    # a string message can contain %{value}, %{attribute} and %{model}
    # message can also be a method, with args (object, data); object is the object being validated, data contains :model, :attribute and :value key-value pairs
  :on                                               # specify when the validation should happen; values can be :create, :update, or custom contexts
  :if                                               # specify conditions that must be true for the validation to take place
  with_options if: bool? do |obj|                   # group validations under single condition
end

# can do callback for lifecycles hooks - on_update, on_insert, etc. 
# see https://guides.rubyonrails.org/active_record_callbacks.html
# example:
class User > ApplicationRecord
  validates :login, :email, presence: true
  before_validation :assert_login, on: [ :create, :update ] # can specify specific life cycle events

  private                                           # good practice to declare callback methods as private
    def assert_login
      if login.nil?
        self.login = email unless email.blank?
      end
    end
  
  # can also do this if fits on a single line
  before_create do 
    self.email = login.capitalize if email.blank?
  end

  # all available callbacks:
  # when creating an object:
  before_validation                                
  after_validation
  before_save
  around_save
  before_create
  around_create
  after_create
  after_save                                        # always runs after after_create
  after_commit
  after_rollback

  # when updating an object:
  before_validation
  after_validation
  before_save
  around_save
  before_update
  around_update
  after_save                                        # always runs after after_update
  after_commit
  after_rollback

  # when deleting an object
  before_destroy
  around_destroy
  after_destroy
  after_commit
  after_rollback

  # other callbacks
  after_initialize                                  # called whenever ActiveRecord is initialized using `new` or when loaded from the DB
  after_find                                        # called after a record is loaded from DB; always called before ater_initialize; triggered by methods all, first, find, find_x, last
  after_touch 

  # avoid updating or saving attributes in callbacks, instead assign values directly in before_create/update or earlier callbacks

  # these methods skip callbacks, use with caution when callbacks are necessary to healthy data logic
  decrement
  decrement_counter
  delete
  delete_x 
  increment 
  increment_counter 
  insert 
  insert_all 
  touch_all 
  update_x
  upsert
  upsert_all

  # callbacks are queued for execution; the callback chain is wrapped in a transaction; if that transaction fails the entire chain gets halted and rollback is performed
  throw :abort                                      # stop a rollback chain

  # can use :if and :unless option to make callbacks conditional

end


# Migrations: domain-specific language for managing a database schema, stored in files executed against supported database through `rake`
# database-agnostic
# example for table creation:
class CreatePublications < ActiveRecord::Migration[7.0]
  def change
    create_table :publications do |t|
      t.string :title
      t.text :description
      t.references :publication_type
      t.references :publisher, polymorphic: true
      t.boolean :single_issue

      t.timestamps
    end
  end
end
# rails keep track of which files have been comitted to the DB and provides rollback features
# see https://guides.rubyonrails.org/active_record_migrations.html
# to create the table: 
print "bin/rails db:migrate"
# to roll back the table:
print "bin/rails db:rollback"

bin/rails generate migration AddPartNumberToProducts part_number:string:index
  # =>
  class AddPartNumberToProducts < ActiveRecord::Migration[7.0]
    def change
      add_column :products, :part_number, :string
      add_index :products, :part_number
    end
  end
  
bin/rails generate migration RemovePartNumberFromProducts part_number:string
  # =>
  class RemovePartNumberFromProducts < ActiveRecord::Migration[7.0]
    def change
      remove_column :products, :part_number, :string
    end
  end

bin/rails generate migration AddDetailsToProducts part_number:string price:decimal
  # =>
  class AddDetailsToProducts < ActiveRecord::Migration[7.0]
    def change
      add_column :products, :part_number, :string
      add_column :products, :price, :decimal
    end
  end

bin/rails generate migration AddUserRefToProducts user:references
  # => 
  class AddUserRefToProducts < ActiveRecord::Migration[7.0]
    def change
      add_reference :products, :user, foreign_key: true
    end
  end

bin/rails generate migration CreateJoinTableCustomerProduct customer product
  # =>
  class CreateJoinTableCustomerProduct < ActiveRecord::Migration[7.0]
    def change
      create_join_table :customers, :products do |t|
        # t.index [:customer_id, :product_id]
        # t.index [:product_id, :customer_id]
      end
    end
  end
  
# modifiers
bin/rails generate migration AddDetailsToProducts 'price:decimal{5,2}' supplier:references{polymorphic}
  # =>
  class AddDetailsToProducts < ActiveRecord::Migration[7.0]
    def change
      add_column :products, :price, :decimal, precision: 5, scale: 2
      add_reference :products, :supplier, polymorphic: true
    end
  end

# Associations: connection between two ActiveRecord models, ie relations
# see https://guides.rubyonrails.org/association_basics.html
# example:
class Store < ApplicationRecord
  has_many :products, dependent: destroy
end

class Product < ApplicationRecord
  belongs_to :store
end

some_product = @store.products.create(name: '...')  # creating a submodel

# association types:
class Book < ApplicationRecord
  belongs_to :author                                # [1,?] association when used on its own; this model knows of its parent model, but the parent doesn't know about it
    # in this case, creates book.author_id
    # use in combination with has_one or has_many in parent for bidirectional associations
    # on its own, belongs_to does not enforce reference consistency; use :foreign-key option to ensure fk integrity
    # in migrations, use t.references :author, index: true, foreign_key: true
    # for associations that use a different name than the model, use t.references :main_author, foreign_key: { to_table: :authors }
  has_one :cover_page                               # [1,1] association
    # in this case, creates page.book_id
    # use :index option with :unique option for unique index, can also enforce fk integrity with :foreign-key
  has_many :pages                                   # [1,n] association
    # pluralize model name
    # pair with belongs_to for proper [1,n] relationship
    # usually a good index to use :index and :foreign-key
  has_many :pages, through: :chapters               # [n,n] associations
    # in this case, `chapter` would be the intermediate table between `word` and `book` with both book.id and page.id fields
    # models deleted through association cascade do not trigger destroy callbacks
    # can do @book.pages directly, without going through chapters
  has_one :publisher, through: :book_deals          # [1,1] association through an intermediate table
    # in this case, `book_deal` has a book.id and publisher.id; can access through @book.publisher
  has_and_belongs_to_many :references               # [n,n] associations
    # use when the relationship entity doesn't need to be worked with and if there is no need for validations, callbacks, etc.

  # polymorhpic associations allow models to belong to more than one other model
  belongs_to :printable, polymorphic: true          # any class implementing `has_many :books, as: :printable` can use book

  # self joins
  has_many :inspiration, class_name: "Book", foreign_key: "inspired_id"
  belongs_to :inspired, class_name: "Book", optional: true
end

# cli generation shortcuts
# belongs_to
bin/rails generate model Article references:store
# single-table inheritance
bin/rails generate model Animal type:string
bin/rails generate model Dog --skip-migration   # change dog.rb Dog < ActiveRecord::Base to Dog < Animal

# tips
# reload cache
author.books.load               # load from db into cache
author.books.reload.empty?      # discard cache

# avoid using association names that collide with ActiveRecord::Base methods, like `attributes` or `connections`
# need to update the schema to reflect association, namely by doing two things:
  # 1. create foreign keys for belongs_to associations w/ t.references :field in migration or add_reference for existing table
  # 2. create association tables for has_and_belongs_to_many associations w/ create_table with :id false (because it doesn't match a model) or create_join_table
# by default associations only look within current module scope, use Module::Model to import models from other modules
# ActiveRecord doesn't automatically identify bi-directional associations with :through or :foreign-key
  # use :inverse-of to explicitly declare bi-directional associations in these cases
