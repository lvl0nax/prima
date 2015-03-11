ActiveAdmin.register Product do

  permit_params "title", "brand", "value_type", "value_price", "user_id", "category_id", "img_product", "description", "filters", "discount", "status"

end
