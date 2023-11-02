require 'rails_helper'

RSpec.describe Todo, type: :model do
  # ensure Todo model has 1:m relationship with Item model
  it { should have_many(:items).dependent(:destroy) }

  # ensure columns title and created_by are present
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:created_by) }
end
