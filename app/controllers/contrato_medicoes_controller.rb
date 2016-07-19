class ContratoMedicoesController < ApplicationController
  before_action :find_contrato, only: [:show, :update, :destroy]

  def index
    @total = ContratoMedicao.count
    @contratos = ContratoMedicao.all
  end

  def show
  end

  def create
    @contrato = ContratoMedicao.new(contrato_params)

    if @contrato.save
      render :show
    else
      render json: { errors: @contrato.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @contrato.update contrato_params
      render :show
    else
      render json: { errors: @contrato.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @contrato.destroy
      render json: {}, status: :ok
    else
      render json: { errors: @contrato.errors }, status: :unprocessable_entity
    end
  end

  private

  def find_contrato
    @contrato = ContratoMedicao.find(params[:id])
  end

  def contrato_params
    params.require(:contrato_medicao)
      .permit(:numero,
              :vigencia_inicial,
              :vigencia_final,
              :data_assinatura,
              :empresa_id)

  end
end
