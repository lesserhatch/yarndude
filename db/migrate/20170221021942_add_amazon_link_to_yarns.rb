class AddAmazonLinkToYarns < ActiveRecord::Migration[5.0]
  def change
    add_column :yarns, :amazon_affiliate_url, :string
  end
end
