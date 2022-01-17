class InstructorsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

    def index 
        render json: Instructor.all 
    end

    def show
        instructor = find_instructor
        render json: instructor 
    end

    def create 
        instructor = Instructor.create!(instructor_params)
        render json: instructor, status: :created
    rescue ActiveRecord::RecordInvalid => invalid 
        render json: { errors: invalid.record.errors.full_message }, status: :unprocessable_entity 
    end

    def update
        instructor = find_instructor
        render json: instructor.update(instructor_params), status: :accepted
    end

    def destroy
        instructor = find_instructor
        instructor.destroy
        head :no_content
    end

    private

    def find_instructor
        Instructor.find(params[:id])
    end

    def instructor_params
        params.permit(:id, :name)
    end

    def render_not_found_response 
        render json: {errors: "Not Found"}, status: :not_found
    end

end
