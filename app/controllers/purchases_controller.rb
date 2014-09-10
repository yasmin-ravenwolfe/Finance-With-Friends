class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :update, :destroy]

  # GET /purchases
  # GET /purchases.json
  def index
    @receipt = Receipt.find params[:receipt_id]
    @purchases = @receipt.purchases
  end

  # GET /purchases/1
  # GET /purchases/1.json
  def show
  end

  # GET /purchases/new
  def new
    @purchase = Purchase.new
    @receipt = Receipt.find params[:receipt_id]
    @group = @receipt.group
    @categories = @group.categories
    @memberships = @group.memberships
  end

  # GET /purchases/1/edit
  def edit
  end

  # POST /purchases
  # POST /purchases.json
  def create
    @receipt = Receipt.find params[:receipt_id]
    @purchase = @receipt.purchases.new(purchase_params)
    @memberships = @purchase.receipt.group.memberships
    # ytf TODO: Create purchase through receipt or independently, passing in receipt_id from params?
    # @purchase.receipt_id = params[:receipt_id]
    @purchase.description = params[:purchase][:description]
    @purchase.category_id = params[:purchase][:category_id]
    @purchase.price = params[:purchase][:price]
    @purchase.quantity = params[:purchase][:quantity]
    @purchase.tax = (params[:purchase][:tax].to_d / 100).to_d

    if params[:purchase][:split] == "1"
      @purchase.split = true
    else
      @purchase.split = false
      # one_person_purchase = @purchase.splits.new
      # @split.membership_id = params[:split][:membership_id]
      # @split.percentage = 1
    end

    calculate_taxed_total(@purchase)

    respond_to do |format|
      if @purchase.split && @purchase.save
        format.html { redirect_to new_purchase_split_path(@purchase), notice: 'Purchase was successfully created.' }
        format.json { render action: 'show', status: :created, location: @purchase }
      elsif @purchase.save
        format.html { redirect_to group_receipts_path(@receipt.group), notice: 'Purchase was successfully created.' }
        format.json { render action: 'show', status: :created, location: @purchase }
      else
        format.html { render action: 'new' }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchases/1
  # PATCH/PUT /purchases/1.json
  def update
    respond_to do |format|
      if @purchase.update(purchase_params)
        format.html { redirect_to @purchase, notice: 'Purchase was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases/1
  # DELETE /purchases/1.json
  def destroy
    @purchase.destroy
    respond_to do |format|
      format.html { redirect_to purchases_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase
      @purchase = Purchase.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_params
      params.require(:purchase).permit(:receipt_id, purchase: [:description, :category_id, :price, :quantity, :tax, :split, :percentage, :membership_id_split, :membership_id_one_buyer] )
    end

    def calculate_taxed_total(purchase)
      sub_total = purchase.price * purchase.quantity
      total_with_tax = (purchase.tax * sub_total) + sub_total

      purchase.taxed_total = total_with_tax
    end
end
