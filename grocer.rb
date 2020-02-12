def find_item_by_name_in_collection(name, collection)
  counter = 0
    while counter < collection.length
    if collection[counter][:item] == name
      return collection[counter]
    end
    counter += 1
  end
end

def consolidate_cart(cart)
  new_cart = []
  counter = 0
    while counter < cart.length
      new_cart_item = find_item_by_name_in_collection(cart[counter][:item], new_cart)
      new_cart_item
      if new_cart_item != nil
        new_cart_item[:count] += 1
      else
        new_cart_item = {
          :item => cart[counter][:item],
          :price => cart[counter][:price],
          :clearance => cart[counter][:clearance],
          :count => 1
        }
        new_cart << new_cart_item
      end
      counter += 1
    end
    new_cart
end

# apply_coupons notes
# take the most logical approach to this
# what do we want to loop though? the cart and apply coupons? or the
# coupon array and see if it matches items in the cart?

def apply_coupons(cart, coupons)
  counter = 0
  # doesn't break if there is no coupon
  while counter < coupons.length
    # check coupons to see if it matches any of our cart items
    cart_item = find_item_by_name_in_collection(coupons[counter][:item], cart)
    # does the coupon item exist in the cart? change name to add "W/COUPON"
    couponed_item_name = "#{coupons[counter][:item]} W/COUPON"
    cart_item_with_coupon = find_item_by_name_in_collection(couponed_item_name, cart)
    # checks if the item is in the cart and that the count satisfies the coupon reqs
    # doesn't break if the coupon doesn't apply to any items
    if cart_item && cart_item[:count] >= coupons[counter][:num]
      # can apply multiple coupons
      if cart_item_with_coupon
        cart_item_with_coupon[:count] += coupons[counter][:num]
        cart_item[:count] -= coupons[count][:num]
      else
        # adds the coupon price to the property hash of couponed item
        cart_item_with_coupon = {
          :item => couponed_item_name,
          # adds the coupon price to the property hash of couponed item
          :price => coupons[counter][:cost] / coupons[counter][:num],
          # adds the count number to the property hash of couponed item
          :count => coupons[counter][:num],
          # remembers if the item was on clearance
          :clearance => cart_item[:clearance]
        }
        cart << cart_item_with_coupon
        # removes the number of discounted items from the original item's count
        cart_item[:count] -= coupons[counter][:num]
        end
      end
    counter += 1
  end
  cart
end

def apply_clearance(cart)
  counter = 0
  while counter < cart.length
    # does not discount the price for items not on clearance
    if cart[counter][:clearance]
      # takes 20% off price if the item is on clearance
      cart[counter][:price] = (cart[counter][:price] - (cart[counter][:price] * 0.20)).round(2)
    end
    counter += 1
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  total = 0
  counter = 0
    while counter < final_cart.length
      total += final_cart[counter][:price] * final_cart[counter][:count]
      counter += 1
    end
    if total > 100
    total -= (total * 0.10).round(2)
    end
    total
end
