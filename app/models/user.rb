class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, :lockable,
         :omniauthable, omniauth_providers: %i[google_oauth2 facebook]

  validates :name, presence: true, length: { maximum: 100 }

  scope :admins, -> { where(admin: true) }

  # Teams the user has created (as “owner”)
  has_many :user_teams_created,
           class_name: "UserTeam",
           foreign_key: :creator_id,
           dependent: :nullify

  # Teams the user is a member of
  has_many :user_team_memberships, dependent: :destroy
  has_many :user_teams, through: :user_team_memberships, source: :user_team

  # Registrations (for upcoming matches)
  has_many :registrations, dependent: :nullify
  has_many :registered_teams, through: :registrations, source: :team
  has_many :registered_matches, through: :registered_teams, source: :match

  def name_or_email
    name.presence || email
  end

  # ---- OmniAuth helper ----
  def self.from_omniauth(auth)
    # 1) Try by provider + uid
    user = find_by(provider: auth.provider, uid: auth.uid)

    # 2) Fallback: existing user with same email (link accounts)
    if user.nil? && auth.info.email.present?
      user = find_by(email: auth.info.email.downcase)
    end

    # 3) Create new user if none found
    if user.nil?
      user = new(
        email: auth.info.email&.downcase,
        name:  auth.info.name.presence ||
               auth.info.nickname.presence ||
               auth.info.email.split("@").first,
        password: Devise.friendly_token[0, 20]
      )

      # Provider has already verified their email → skip confirmation flow
      user.skip_confirmation! if user.respond_to?(:skip_confirmation!)
    end

    user.provider = auth.provider
    user.uid      = auth.uid
    user.save!
    user
  end
end
