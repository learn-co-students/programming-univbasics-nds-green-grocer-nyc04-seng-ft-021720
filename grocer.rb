def find_item_by_name_in_collection(name, collection)
  # Implement me first!
  #
  # Consult README for inputs and outputs
  
  collection.length.times do |i|
    thisitem = collection[i]
    if thisitem[:item] == name then
      return thisitem
    else
      # do nothing, loop to the next item
    end
  end
  
  # if item not found and return not arrived at above, return nil
  nil
end

def consolidate_cart(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
  
  output = []
  
  cart.length.times do |i|
    item_in_cart = find_item_by_name_in_collection(cart[i][:item], output)
    if item_in_cart
      # in there, increment it
      item_in_cart[:count] += 1
    else
      # not in there, add it
      row = cart[i]
      # add the :count key
      row[:count] = 1
      # push onto the array
      output.push(row)
    end
  end
  
  output
end

def apply_coupons(cart, coupons)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  
  # output = []
  
  # # loop over the cart
  # cart.length.times do |i|
  #     itemmatch = false
  #     # loop over the coupons
  #     coupons.length.times do |j|
  #         # if the coupon item matches the cart item
  #         if coupons[j][:item] == cart[i][:item] then
  #             itemmatch = true
  #             # if there are sufficient matching items in the cart
  #             if cart[i][:count] >= coupons[j][:num] then
  #                 # get the number of undiscountable items
  #                 remainder = cart[i][:count] % coupons[j][:num]
  #                 # get the number of discountable items
  #                 discountednum = cart[i][:count] - remainder
  #                 # open an object, copied from the cart
  #                 discountedobject = cart[i]
  #                 # modify the price
  #                 discountedobject[:price] = coupons[j][:cost] / coupons[j][:num]
  #                 # modify the quantity
  #                 discountedobject[:count] = discountednum
  #                 # modify the item name
  #                 discountedobject[:item] = discountedobject[:item] + ' W/COUPON'
  #                 # add the discounted object to the array
  #                 output.push(discountedobject)
  #                 if remainder > 0 then
  #                     # open an object, copied from the cart
  #                     fullpriceobject = cart[i]
  #                     # modify the quantity
  #                     fullpriceobject[:count] = remainder
  #                     # add the fullprice object to the array
  #                     output.push(fullpriceobject)
  #                 end
  #             else
  #                 # not enough quantity to use the coupons, add base object to the array
  #                 output.push(cart[i])
  #             end
  #             # coupon didnt match, do nothing
  #         end
  #         #end of coupon loop
  #     end
  #     if (!itemmatch) then 
  #         # no item-coupon match, add to cart as is
  #         output.push(cart[i])
  #     end
  #     #end of cart loop
  # end
  
  # cart = output
  
  coupons.length.times do |i|
    cart_item = find_item_by_name_in_collection(coupons[i][:item], cart)
    couponed_item_name = "#{coupons[i][:item]} W/COUPON"
    cart_item_with_coupon = find_item_by_name_in_collection(couponed_item_name, cart)
    
    if cart_item && cart_item[:count] >= coupons[i][:num]
      if cart_item_with_coupon
        # increase count
        cart_item_with_coupon[:count] += coupons[i][:num]
        cart_item[:count] -= coupons[i][:num]
      else
        # add cart item with coupon
        cart_item_with_coupon = {
          item: couponed_item_name,
          price: (coupons[i][:cost] / coupons[i][:num]).round(2),
          count: coupons[i][:num],
          clearance: cart_item[:clearance]
        }
        cart.push(cart_item_with_coupon)
        cart_item[:count] -= coupons[i][:num]
      end
    end
  end
  
  cart
end

def apply_clearance(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  
  output = cart
  
  output.length.times do |i|
    if output[i][:clearance] then
      output[i][:price] = (output[i][:price] * (1 - 0.2)).round(2)
    end
  end
  
  cart = output
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
  
  consolidated = consolidate_cart(cart)
  pp consolidated
  couponed = apply_coupons(consolidated, coupons)
  clearanced = apply_clearance(couponed)
  
  total = 0
  clearanced.length.times do |i|
    total += (clearanced[i][:price] * clearanced[i][:count])
  end
  
  if total > 100 then
    total = total * 0.90
  end 
  
  total
end
