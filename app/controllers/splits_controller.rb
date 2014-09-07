class SplitsController < ApplicationController
  before_action :set_split, only: [:show, :edit, :update, :destroy]

  # GET /splits
  # GET /splits.json
  def index
    @splits = Split.all
  end

  # GET /splits/1
  # GET /splits/1.json
  def show
  end

  # GET /splits/new
  def new
    @split = Split.new
    @purchase = Purchase.find params[:purchase_id]
    @memberships = @purchase.receipt.group.memberships
  end

  # GET /splits/1/edit
  def edit
    @split = Split.find params[:id]
    @split.percentage = @split.percentage * 100
    @purchase = @split.purchase
    # raise Split.splits_total_percentage_by_purchase(@purchase).inspect
    @memberships = @purchase.receipt.group.memberships
  end

  # POST /splits
  # POST /splits.json
  def create
    @purchase = Purchase.find params[:purchase_id]
    @receipt = @purchase.receipt
    @memberships = @purchase.receipt.group.memberships
    @split = @purchase.splits.new(split_params)
    @split.membership_id = params[:split][:membership_id]
    @split.percentage = params[:split][:percentage].to_d/100


    respond_to do |format|
      # if Split.percentage_total_valid?(@purchase, @split) && @split.save
      #   if Split.percentage_total_equals_100?(@purchase)
      if @split.save
        if Split.percentage_total_equals_100?(@purchase)
          format.html { redirect_to group_receipts_path(@receipt.group), notice: 'Splits = 100% .' }
          format.json { render action: 'show', status: :created, location: @split }
          format.js { }
          else
            format.html { redirect_to new_purchase_split_path(@purchase), notice: "Split for #{Membership.find(@split.membership_id).user.name} was successfully created."}
          end
      else
        @split.percentage = @split.percentage * 100
        format.html { render action: 'new' }
        format.json { render json: @split.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /splits/1
  # PATCH/PUT /splits/1.json
  def update
    @split = Split.find params[:id]
    @purchase = @split.purchase
    @memberships = @purchase.receipt.group.memberships
    # raise Split.splits_total_percentage_by_purchase(@purchase).inspect
    # @split.membership_id = params[:split][:membership_id]
    # raise params[:split][:percentage].inspect
    @split.percentage = params[:split][:percentage].to_d/100
    respond_to do |format|
      if @split.save
        if Split.percentage_total_equals_100?(@purchase)
        format.html { redirect_to group_receipts_path(@purchase.receipt.group), notice: 'Splits = 100% .' }
        format.json { render action: 'show', status: :created, location: @split }
        format.js { }
        else
          @split.percentage = @split.percentage * 100
          # format.html { redirect_to new_purchase_split_path(@purchase) }
          format.json { render json: @split.errors, status: :unprocessable_entity }
        end
      else
        # raise @split.errors.inspect
        @split.percentage = @split.percentage * 100
        format.html { render action: 'edit'}
        format.json { render json: @split.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /splits/1
  # DELETE /splits/1.json
  def destroy
    @split.destroy
    respond_to do |format|
      format.html { redirect_to splits_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_split
      @split = Split.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def split_params
      params.require(:split).permit(:purchase_id, split: [:membership_id, :percentage])
    end
end
