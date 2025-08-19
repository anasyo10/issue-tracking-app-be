# Testing with RSpec

This project uses RSpec for testing instead of Rails' default test framework.

## Setup

RSpec is configured with the following gems:

- **rspec-rails**: Main RSpec framework for Rails
- **factory_bot_rails**: For creating test data factories
- **shoulda-matchers**: For simplified ActiveRecord and validation testing
- **database_cleaner-active_record**: For database cleanup between tests

## Running Tests

```bash
# Run all specs
bundle exec rspec

# Run specific spec file
bundle exec rspec spec/models/project_spec.rb

# Run specific test
bundle exec rspec spec/models/project_spec.rb:10

# Run with documentation format
bundle exec rspec --format documentation

# Run with coverage (if you add simplecov)
COVERAGE=true bundle exec rspec
```

## Test Structure

```
spec/
├── controllers/           # Controller specs
├── models/               # Model specs
├── factories/            # Factory definitions
├── fixtures/             # Test fixtures (if any)
├── support/              # Shared examples and helpers
├── rails_helper.rb       # Rails-specific RSpec configuration
└── spec_helper.rb        # General RSpec configuration
```

## Writing Tests

### Model Specs

```ruby
# spec/models/project_spec.rb
require 'rails_helper'

RSpec.describe Project, type: :model do
  it { should validate_presence_of(:name) }
  it { should have_many(:issues) }

  describe "associations" do
    it "destroys associated issues when destroyed" do
      project = create(:project, :with_issues)
      expect { project.destroy }.to change(Issue, :count).by(-3)
    end
  end
end
```

### Controller Specs

```ruby
# spec/controllers/projects_controller_spec.rb
require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe "GET #index" do
    it "returns success response" do
      get :index, as: :json
      expect(response).to have_http_status(:success)
    end
  end
end
```

### Using Factories

```ruby
# Create a project
project = create(:project)

# Create a project with issues
project = create(:project, :with_issues)

# Create an active issue
issue = create(:issue, :active)

# Create a resolved issue
issue = create(:issue, :resolved)

# Build without saving
project = build(:project, name: "Custom Name")

# Create multiple
projects = create_list(:project, 5)
```

## Factory Definitions

Factories are defined in `spec/factories/` and include:

- **Projects**: Basic project factory with optional issues
- **Issues**: Issue factory with status traits (:active, :on_hold, :resolved)
- **Comments**: Comment factory linked to issues

## Shoulda Matchers

Common matchers available:

### Validation Matchers

```ruby
it { should validate_presence_of(:name) }
it { should validate_length_of(:name).is_at_most(255) }
it { should validate_uniqueness_of(:email) }
```

### Association Matchers

```ruby
it { should belong_to(:project) }
it { should have_many(:issues) }
it { should have_many(:issues).dependent(:destroy) }
```

### Database Matchers

```ruby
it { should have_db_column(:name).of_type(:string) }
it { should have_db_index(:email) }
```

## Best Practices

1. **Use factories instead of fixtures** for test data
2. **Use descriptive test names** that explain what is being tested
3. **Group related tests** using `describe` and `context` blocks
4. **Use `before` hooks** to set up test data
5. **Test one thing per example** - keep tests focused
6. **Use shoulda-matchers** for simple validation and association tests
7. **Test both positive and negative cases**

## Continuous Integration

To run tests in CI, use:

```bash
# Prepare test database
RAILS_ENV=test bundle exec rails db:create db:migrate

# Run tests
bundle exec rspec
```

## Coverage (Optional)

To add test coverage reporting, add to your Gemfile:

```ruby
group :test do
  gem 'simplecov', require: false
end
```

Then add to the top of `spec_helper.rb`:

```ruby
require 'simplecov'
SimpleCov.start 'rails'
```
