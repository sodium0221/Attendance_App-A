require 'csv'
class User < ApplicationRecord
  attribute :designated_work_start_time, :datetime, default: "9:00"
  attribute :designated_work_end_time,   :datetime, default: "18:00"
  has_many :attendances, dependent: :destroy
  # 「remember_token」と言う仮装の属性を作成します。
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :affiliation, length: { in: 2..30 }, allow_blank: true
  validates :basic_time, presence: true
  validates :work_time, presence: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  validates_associated :attendances
  
  # importメソッド
  def self.import(file)
    @count = 0
    CSV.foreach(file.path, encoding: 'Windows-31J:UTF-8', headers: true) do |row|
      # idが見つかれば、レコードを呼び出し、見つからなければ、新しく作成
      @file = find_by(id: row["id"]) || new
      # CSVからデータを取得し、設定する
      @file.attributes = row.to_hash.slice(*updatable_attributes) 
      if @file.valid?
        @file.save
        @count += 1
      end
    end
    return @count
  end
  
  # 更新を許可するカラムを定義
  def self.updatable_attributes
    ["name", "email", "affiliation", "employee_number", "uid", "basic_time", 
     "designated_work_start_time", "designated_work_end_time", "superior", "admin", "password"]
  end
  
  def self.to_csv
    headers = %w(日付 出社 退社)
    csv_data = CSV.generate(headers: headers, write_headers: true) do |csv|
      all.each do |row|
        csv << row.attributes.values_at(*self.column_names)
      end 
    end 
    csv_data.encode(Encoding::SJIS)
  end 
  
  
  
  
  # 渡された文字列のハッシュ値を返します。
  def User.digest(string)
  cost = 
    if ActiveModel::SecurePassword.min_cost
      BCrypt::Engine::MIN_COST
    else
      BCrypt::Engine.cost
    end
  BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返します。
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end 
  
  # トークンがダイジェストと一致すればtrueを返します。
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄します。
  def forget
    update_attribute(:remember_digest, nil)
  end


end
