class ItemsController<ApplicationController

  def index
    if params[:merchant_id]
      @merchant = Merchant.find(params[:merchant_id])
      @items = @merchant.items
    else
      @items = Item.all
    end
  end

  def show
    @item = Item.find(params[:id])
    if params[:sort] == 'highest'
      @reviews = @item.highest_reviews
    elsif params[:sort] == 'lowest'
      @reviews = @item.lowest_reviews
    else params[:sort] == nil
      @reviews = @item.reviews
    end
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    item = merchant.items.create(item_params)
    if item.save
      redirect_to "/merchants/#{merchant.id}/items"
    else
      if item_params.each do |key, value|
          if value == ""
            flash[:notice] = "Please enter your item #{key}."
          end
        end
        @merchant = merchant
        render :new
      end
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    item = Item.find(params[:id])
    item.update(item_params)
    if item.save
      redirect_to "/items/#{item.id}"
    else
      if item_params.each do |key, value|
          if value == ""
            flash[:notice] = "Please enter your item #{key}."
          end
        end
        @item = item
        render :edit
      end
    end
  end

  def destroy
    item = Item.find(params[:id])
    reviews = Review.where(item_id: item.id).destroy_all
    item.destroy
    redirect_to "/items"
  end

  private

  def item_params
    params.permit(:name,:description,:price,:inventory,:image)
  end

end
