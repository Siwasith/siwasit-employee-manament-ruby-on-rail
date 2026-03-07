class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[show edit update destroy]

  def index
    @employees = Employee.all
  end

  def show; end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.create(employee_params)
    redirect_to employees_path, notice: "เพิ่มพนักงานสำเร็จ"
  end

  def edit; end

  def update
    @employee.update(employee_params)
    redirect_to employees_path, notice: "แก้ไขข้อมูลสำเร็จ"
  end

  def destroy
    @employee.destroy
    redirect_to employees_path, notice: "ลบพนักงานสำเร็จ"
  end

  private

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:name, :position, :salary)
  end
end
