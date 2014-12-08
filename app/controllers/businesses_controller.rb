class BusinessesController < ApplicationController
  before_action :set_business, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json

  def index
    @businesses = Business.all.includes(:location, :category)
    # respond_with @businesses
  end

  def get_markers
    businesses = Business.includes(:location, :category).all
    Rails.logger.error("Business: #{businesses}")
    geojson = {
          "type" => "FeatureCollection",
          "features" => []
        }
    if businesses.size > 0
      businesses.each do |business|
        if business.category.present?
          if business.location.present?
            geojson["features"] << {
              type: 'Feature',
              properties: {
                title: business.name,
                address: business.address,
                category: business.category.display_name,
                image: get_biz_img(business.image),
                zipcode: business.zipcode,
                :'marker-color' => business.category.color,
                :'marker-symbol' => 'circle',
                :'marker-size' => 'medium'
              },
              geometry: {
                type: 'Point',
                coordinates: [business.location.longitude, business.location.latitude]
              }
            }
          else
            Rails.logger.error("no lat/long")
          end
        else
          Rails.logger.error("no category, migration error")
        end
      end
    else
      Rails.logger.error("Size is 0")
    end

    render json: geojson

  end

  def get_biz_img(img_url)  
    img_urls = img_url.split('//')
    "http://#{img_urls[1]}"
  end

 private

  def set_business
    @business = Business.find(params[:id])
  end

  def business_params
    params.require(:business).permit(:name, :image, :zipcode, :address,
      category_attributes: [:name],
      location_attributes:[:latitude, :longitude])
  end

end