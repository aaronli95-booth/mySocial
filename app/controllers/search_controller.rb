class SearchController < ApplicationController
  def index
    if params[:query].present?
      query = params[:query].downcase.strip
      
      # Split query into words for better matching
      query_words = query.split(/\s+/)
      
      # Base query with all searchable fields
      @users = User.where(build_search_conditions(query))
                  .select("users.*, 
                          CASE 
                            WHEN LOWER(school) = ? THEN 100
                            WHEN LOWER(school) LIKE ? THEN 50
                            WHEN LOWER(first_name) = ? OR LOWER(last_name) = ? THEN 40
                            WHEN LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? THEN 30
                            WHEN LOWER(email_address) LIKE ? THEN 20
                            ELSE 10
                          END as relevance")
                  .order('relevance DESC, school ASC, first_name ASC, last_name ASC')
                  .limit(20)
    else
      @users = []
    end
  end

  private

  def build_search_conditions(query)
    conditions = []
    parameters = []
    
    # Exact matches
    conditions << "LOWER(school) = ?"
    parameters << query
    
    # Partial matches
    conditions << "LOWER(school) LIKE ?"
    parameters << "#{query}%"
    
    conditions << "LOWER(first_name) = ?"
    parameters << query
    
    conditions << "LOWER(last_name) = ?"
    parameters << query
    
    conditions << "LOWER(first_name) LIKE ?"
    parameters << "#{query}%"
    
    conditions << "LOWER(last_name) LIKE ?"
    parameters << "#{query}%"
    
    conditions << "LOWER(email_address) LIKE ?"
    parameters << "%#{query}%"
    
    # Combine all conditions with OR
    [conditions.join(" OR "), *parameters]
  end
end 