class Artist < ApplicationRecord
    include AtScopes
    include SearchCop

  ## RELATIONSHIPS

    has_many :concerts
    has_one_attached :photo

  ## VALIDATIONS

    #validates :company_name, :short_name, presence: true
    #validates :company_name, uniqueness: true
    #validates :cif, format: {with:/\A[A-Z]{1}\d{8}\z/, message: I18n.t("errors.companies.invalid_cif")}

  ## SCOPES

    # search_scope :search do #text search fields
    #     attributes :company_name, :short_name#, :cif
    #   end

  ## CLASS METHODS

    # def self.do_search(current_user, params={}, order_by="tin")
    #     params ||= {}
    #     companies = Company.order(order_by)
    #     #Dates search
    #     companies = apply_at_scopes(companies, params)
    #     #Text search
    #     companies = companies.search(params[:text]) if params[:text].present?
    #     companies
    # end

  ## INSTANCE METHODS

    def complete_name #Complete name
      name
    end

end