class GeneralController < ApplicationController
  def welcome
  end

  def our_coaches
    @coaches = User.where('role = ?', "Coach")
  end

  def testimonials
  end

  def recipes
  end

  def about_us
  end

  def terms
  end
end
