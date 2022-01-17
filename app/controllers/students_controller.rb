class StudentsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

    def index 
        render json: Student.all 
    end

    def show
        student = find_student
        render json: student, include: :instructor
    end

    def create 
        student = Student.create!(student_params)
        render json: student.instructor, status: :created
    rescue ActiveRecord::RecordInvalid => invalid 
        render json: { errors: invalid.record.errors.full_message }, status: :unprocessable_entity 
    end

    def update
        student = find_student
        render json: student.update(student_params), status: :accepted
    end

    def destroy
        student = find_student
        student.destroy
        head :no_content
    end

    private

    def find_student
        Student.find(params[:id])
    end

    def student_params
        params.permit(:id, :name, :major, :age, :instructor_id)
    end

    def render_not_found_response 
        render json: {errors: "Not Found"}, status: :not_found
    end

end
