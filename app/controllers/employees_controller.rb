class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[show edit update destroy]
  skip_forgery_protection if: :json_request?

  def index
    @employees = Employee.all
    respond_to do |format|
      format.html
      format.json { render json: @employees.map(&:as_json) }
    end
  end

  def admin
    @employees = Employee.all
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @employee.as_json }
    end
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    
    respond_to do |format|
      if @employee.save
        format.html { redirect_to employees_path, notice: "เพิ่มพนักงานสำเร็จ" }
        format.json { render json: @employee.as_json, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { errors: "Unable to create employee" }, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to employees_path, notice: "แก้ไขข้อมูลสำเร็จ" }
        format.json { render json: @employee.as_json }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { errors: "Unable to update employee" }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_path, notice: "ลบพนักงานสำเร็จ" }
      format.json { render json: { success: true, message: "ลบพนักงานสำเร็จ" } }
    end
  end

  private

  def set_employee
    @employee = Employee.find(params[:id])
    return if @employee.present?
    redirect_to employees_path, notice: "ไม่พบพนักงาน"
  end

  def employee_params
    params.require(:employee).permit(:name, :position, :salary)
  end

  def json_request?
    request.format.json?
  end
end
