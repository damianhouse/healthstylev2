class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #   :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :conversations, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :notes, dependent: :destroy
  validates :first_name, :last_name, :phone_number, :terms_read, presence: true
  validates :greeting, presence: true, if: :is_coach?
  validates :philosophy, presence: true, if: :is_coach?
  validates_uniqueness_of :email, allow_blank: true
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>", original: {convert_options: '-auto-orient'} }, default_url: "/images/generic_avatar.jpg"
  validates_attachment_content_type :avatar, content_type: /\Aimage\//

  def add_time(plan, interval_count)
    interval_count.to_i
    unless plan.nil?
      if expires_at.nil?
        case plan
        when "week"
          self.expires_at = (DateTime.now + 1.week)
          self.save!
        when "month"
          self.expires_at = (DateTime.now + interval_count.month)
          self.save!
        when "year"
          self.expires_at = (DateTime.now + 1.year)
          self.save!
        else
          return
        end
      else
        case plan
        when "week"
          self.expires_at += 1.week
          self.save!
        when "month"
          self.expires_at += (interval_count.month)
          self.save!
        when "year"
          self.expires_at += 6.month
          self.save!
        else
          return
        end
      end
    end
  end

  def remove_time(plan, interval_count)
    interval_count.to_i
    unless plan.nil?
      if expires_at.nil?
        case plan
        when "week"
          self.expires_at = (DateTime.now - 1.week)
          self.save!
        when "month"
          self.expires_at = (DateTime.now - interval_count.month)
          self.save!
        when "year"
          self.expires_at = (DateTime.now - 1.year)
          self.save!
        else
          return
        end
      else
        case plan
        when "week"
          self.expires_at -= 1.week
          self.save!
        when "month"
          self.expires_at -= (interval_count.month)
          self.save!
        when "year"
          self.expires_at -= 6.month
          self.save!
        else
          return
        end
      end
    end
  end

  def all_coaches_unique?
    coaches = [primary_coach, secondary_coach, tertiary_coach]
    unique_coaches = coaches.uniq
    coaches == unique_coaches
  end

  def active?
    status == 'active'
  end

  def steps
    %w[first_step second_step]
  end

  def current_step
    @current_step ||= steps.first
  end

  def first_step?
    current_step == "first_step"
  end

  def second_step?
    current_step == "second_step"
  end

  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end

  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end

  def last_step?
    self.current_step == steps.last
  end

  def all_valid?
    steps.all? do |step|
      self.current_step = step
      valid?
    end
  end

  def validate_primary_coach
    self.primary_coach.present?
  end

  def validate_secondary_coach
    self.secondary_coach.present?
  end

  def validate_tertiary_coach
    self.tertiary_coach.present?
  end

  def all_coaches_choosen?
    true unless validate_primary_coach && validate_secondary_coach && validate_tertiary_coach
  end

  def is_user?
    is_admin == false && is_coach == false
  end

  def is_coach?
    self.is_coach
  end

  def is_admin?
    self.is_admin
  end

  def expired?
    if expires_at
      false if expires_at > DateTime.now
    else
      true
    end
  end

end
