class GeneralController < ApplicationController
  def welcome
  end

  def our_coaches
    @coaches = User.where("is_coach = ? AND approved = ?", true, true)
  end

  def testimonials
  end

  def recipes
    @recipe = Recipe.new.random_recipe
  end

  def about_us
  end

  def terms
  end
end
