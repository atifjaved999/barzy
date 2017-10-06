json.id product_category.id
json.name product_category.name
json.description product_category.description

if product_category.products.present?
  json.products product_category.products do |product|
      json.partial! 'api/v1/products/product', product: product
    end
end
