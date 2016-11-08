class GeneralController < ApplicationController
  def welcome
  end

  def our_coaches
    @coaches = User.where('role = ?', "Coach")
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
