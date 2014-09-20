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
    @memberships.size.times { @purchase.splits.build}
  end

  # GET /purchases/1/edit
  def edit
    @receipt = @purchase.receipt
    @group = @receipt.group
    @categories = @group.categories
    @memberships = @group.memberships
    (@memberships.size - @purchase.splits.size).times { @purchase.splits.build }
  end

  # POST /purchases
  # POST /purchases.json
  def create
    @receipt = Receipt.find params[:receipt_id]
    @purchase = @receipt.purchases.new(purchase_params)
    @memberships = @purchase.receipt.group.memberships
    @group = @receipt.group
    @categories = @group.categories
    @purchase.description = params[:purchase][:description]
    @purchase.category_id = params[:purchase][:category_id]
    @purchase.price = params[:purchase][:price]
    @purchase.quantity = params[:purchase][:quantity]
    @purchase.tax = (params[:purchase][:tax].to_d / 100).to_d


    if params[:purchase][:split] == "1"
      @purchase.split = true

      params[:purchase][:splits_attributes].each do |s|
        next if (s[1][:membership_id] == "" && s[1][:percentage]) == "" || (s[1][:membership_id] == "" && s[1][:percentage].to_f == 0)

        @split = @purchase.splits.new
        @split.membership_id = s[1][:membership_id]
        @split.percentage = s[1][:percentage].to_d / 100
      end
    else
      @split = @purchase.splits.new
      @split.membership_id = params[:purchase][:membership_id_one_buyer]
      @split.percentage = 1
    end
    calculate_taxed_total(@purchase)
    respond_to do |format|
      if !@purchase.save
        format.html { render action: 'new' }
        format.json { render json: @split.errors, status: :unprocessable_entity }
        format.js { }
      else
        format.html { redirect_to group_receipts_path(@receipt.group), notice: 'Purchase was successfully created.' }
        format.json { render action: 'receipts/index', status: :created, location: @purchase }
      end
    end
  end

  # PATCH/PUT /purchases/1
  # PATCH/PUT /purchases/1.json
  def update
    @receipt = @purchase.receipt
    @group = @receipt.group
    @memberships = @group.memberships
    @categories = @group.categories
    @purchase.description = params[:purchase][:description]
    @purchase.category_id = params[:purchase][:category_id]
    @purchase.price = params[:purchase][:price]
    @purchase.quantity = params[:purchase][:quantity]
    @purchase.tax = (params[:purchase][:tax].to_d / 100).to_d


    if params[:purchase][:split] == "1"
      @purchase.split = true

      params[:purchase][:splits_attributes].each_with_index do |new_split, old_split_index|
        if (new_split[1][:membership_id] == "" && new_split[1][:percentage]) == "" || (new_split[1][:membership_id] == "" && new_split[1][:percentage].to_f == 0)
          @purchase.splits[old_split_index].destroy if @purchase.splits[old_split_index]
          next
        end

        @split = @purchase.splits[old_split_index] ||= @split = @purchase.splits.new
        @split.membership_id = new_split[1][:membership_id]
        @split.percentage = new_split[1][:percentage].to_d / 100
      end
    else
      @purchase.splits.destroy
      @split = @purchase.splits.new
      @split.membership_id = params[:purchase][:membership_id_one_buyer]
      @split.percentage = 1
    end
    calculate_taxed_total(@purchase)
    respond_to do |format|
      if !@purchase.save
        format.html { render action: 'edit' }
        format.json { render json: @split.errors, status: :unprocessable_entity }
        format.js { }
      else
        format.html { redirect_to group_receipts_path(@receipt.group), notice: 'Purchase was successfully created.' }
        format.json { render action: 'receipts/index', status: :created, location: @purchase }
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
      params.require(:purchase).permit(:receipt_id, purchase: [:description, :category_id, :price, :quantity, :tax, :split, :percentage, :membership_id_split, :membership_id_one_buyer, :split_attributes] )
    end

    def calculate_taxed_total(purchase)
      sub_total = purchase.price * purchase.quantity
      total_with_tax = (purchase.tax * sub_total) + sub_total

      purchase.taxed_total = total_with_tax
    end
end
