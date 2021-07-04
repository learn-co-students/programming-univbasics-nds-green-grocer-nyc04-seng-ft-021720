require 'pp'

def find_item_by_name_in_collection(name, collection)
  collection.each { |grocery|
    if grocery[:item] == name
      return grocery
    end
  }
  nil
end

def consolidate_cart(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
  updated_cart = []
  cart.each { |grocery|
    # if the grocery doesn't exist in the cart, push grocery to updated_cart and count = 1
    # if it does, count += 1
    if !updated_cart.include?(grocery)
      grocery[:count] = 1
      updated_cart.push(grocery)
    else
      grocery[:count] += 1
    end
  }
  updated_cart
end

def apply_coupons(cart, coupons)
#iterate through the coupons 
  # iterate through the cart and check if the item in the coupons array matches a grocery's item in the cart
  #   if the (count of the grocery in the cart) - (num of groceries needed for coupon) < 0
  #     go to the next coupon
  #   else
  #     subtract the count of that grocery in the coupon from the cart
  #     create new grocery with item called "ITEM W/ COUPON", set price of grocery to the coupon price
  cart.each { |grocery|
    coupons.each{ |coupon|
    # looking for a way to move onto the next coupon if it there aren't enough items to apply the coupon
    if grocery[:count] - coupon[:num] < 0
      break
    elsif coupon[:item] == grocery[:item]
      # Subtracting the items the coupon will be applied to
      # Creating a new grocery object with the discount and adding it to the cart
      grocery[:count] -= coupon[:num]
      grocery_with_coupon = {}
      grocery_with_coupon[:item] = "#{grocery[:item]} W/COUPON"
      grocery_with_coupon[:price] = coupon[:cost] / coupon[:num]
      grocery_with_coupon[:clearance] = grocery[:clearance]
      grocery_with_coupon[:count] = coupon[:num]
      cart.push(grocery_with_coupon)
    end
    }
  }
  return cart
end

def apply_clearance(cart)
  # Consult README for inputs and outputs
  # REMEMBER: This method **should** update cart
  result = []
  cart.each { |grocery|
    if grocery[:clearance]
      (grocery[:price] *= 0.8).round(2)
    end
    result.push(grocery)
  }
  return result
end

def checkout(cart, coupons)
  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers
  
  #pp coupons
  total = 0
  consolidated_cart = consolidate_cart(cart)
  coupons_applied = apply_coupons(consolidated_cart, coupons)
  clearance_applied = apply_clearance(coupons_applied)
  clearance_applied.each { |grocery|
    total += (grocery[:price]*grocery[:count])
  }
  if total > 100
    total *= 0.9
  end
  total.round(2)
end
