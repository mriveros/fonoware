class HistorialesPacientesController < ApplicationController

before_filter :require_usuario
skip_before_action :verify_authenticity_token


  def index
  

  end
 

  def lista

    cond = []
    args = []

    if params[:form_buscar_pacientes_id].present?

      cond << "paciente_id = ?"
      args << params[:form_buscar_pacientes_id]

    end

    if params[:form_buscar_paciente_documento].present?

      cond << "documento_persona = ?"
      args << params[:form_buscar_paciente_documento]

    end

    if params[:form_buscar_pacientes_nombre].present?

      cond << "nombre_persona ilike ?"
      args << "%#{params[:form_buscar_pacientes_nombre]}%"

    end

    if params[:form_buscar_pacientes_apellido].present?

      cond << "apellido_persona ilike ?"
      args << "%#{params[:form_buscar_pacientes_apellido]}%"

    end

    if params[:form_buscar_pacientes_direccion].present?

      cond << "direccion ilike ?"
      args << "%#{params[:form_buscar_pacientes_direccion]}%"

    end

    if params[:form_buscar_pacientes_telefono].present?

      cond << "telefono ilike ?"
      args << "%#{params[:form_buscar_pacientes_telefono]}%"

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    if cond.size > 0

      @pacientes =  VPaciente.orden_01.where(cond).paginate(per_page: 10, page: params[:page])
      @total_encontrados = VPaciente.where(cond).count

    else

      @pacientes = VPaciente.orden_01.paginate(per_page: 10, page: params[:page])
      @total_encontrados = VPaciente.count

    end

    @total_registros = VPaciente.count

    respond_to do |f|
      
     f.js
      
    end

  end


  def historial_paciente_detalle_fono

    @paciente = Paciente.where("id = ?", params[:paciente_id]).first
    @paciente_detalle_fono = PacienteDetalleFono.where("paciente_id = ?", params[:paciente_id]).first

    respond_to do |f|

      f.js

    end
    
  end


end