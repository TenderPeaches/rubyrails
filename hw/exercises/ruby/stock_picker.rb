# implement a method that takes in:
    # an array of stock prices, one for the price of a stock on each hypothetical day
# it should return:
    # a pair of days showing the best day to buy and best day to sell

def stock_picker(prices = [])

    largest_gain = {
        'buy' => {
            'date' => nil,
            'value' => nil,
        },
        'sell' => {
            'date' => nil,
            'value' => nil,
        },
        'gain' => 0
    }

    # keep track of cheapest day to buy stocks
    lowest = {
        'date' => nil,
        'value' => nil
    }

    prices.each_with_index { |value, day| 
        
        if largest_gain['buy']['date'].nil?        # first iteration
            largest_gain['buy']['date'] = day
            largest_gain['buy']['price'] = value
            largest_gain['sell']['date'] = day
            largest_gain['sell']['price'] = value

            lowest['date'] = day
            lowest['value'] = value
        end

        if value < lowest['value']
            lowest['date'] = day
            lowest['value'] = value
        end

        if value - lowest['value'] > largest_gain['gain']
            largest_gain['buy']['date'] = lowest['date']
            largest_gain['buy']['value'] = lowest['value']
            largest_gain['sell']['date'] = day
            largest_gain['sell']['value'] = value
            largest_gain['gain'] = value - lowest['value']
        end        
    }

    puts ["Buy on day #" + largest_gain['buy']['date'].to_s, "Sell on day #" + largest_gain['sell']['date'].to_s, "Profit: " + largest_gain['gain'].to_s]
end

stock_picker([2, 10, 8, 3, 15, 12])