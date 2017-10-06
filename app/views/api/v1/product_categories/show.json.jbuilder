json.product_category do 
  json.partial! 'api/v1/product_categories/product_category', product_category: @product_category
end