# Issue Tracking App - API

A RESTful API for managing projects, issues, and comments built with Ruby on Rails. This API serves as the backend for the issue tracking application.

**Frontend Application**: [https://issue-tracking-app-zeta.vercel.app/](https://issue-tracking-app-zeta.vercel.app/)

## Prerequisites

- **Ruby**: 3.2.2 (check `.ruby-version`)
- **Rails**: 8.0.2+
- **PostgreSQL**: 9.1+
- **Node.js**: For asset pipeline (optional for API-only)

## Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd issue-tracking-app
```

### 2. Install Dependencies

```bash
# Install Ruby gems
bundle install

# If you encounter gem conflicts, try:
bundle update
```

### 3. Database Setup

#### Copy Database Configuration

```bash
# Copy the example database configuration
cp config/database.yml.example config/database.yml
```

#### Configure Database

Edit `config/database.yml` with your PostgreSQL credentials:

```yaml
development:
  adapter: postgresql
  encoding: unicode
  database: issue_tracking_app_development
  username: postgres
  password: your_password
  host: localhost
  port: 5432
```

#### Create and Setup Database

```bash
# Create databases
rails db:create

# Run migrations
rails db:migrate

# Seed database (optional)
rails db:seed
```

### 4. Environment Variables

Set up your environment variables (optional):

```bash
# Copy application configuration
cp config/application.yml.example config/application.yml
```

### 5. Start the Server

```bash
# Development server
rails server

# Server will be available at: http://localhost:3000
```

## Testing

This application uses **RSpec** for testing.

### Running Tests

```bash
# Run all specs
bundle exec rspec

# Run with documentation format
bundle exec rspec --format documentation

# Run specific test files
bundle exec rspec spec/models/
bundle exec rspec spec/controllers/projects_controller_spec.rb

# Run specific test
bundle exec rspec spec/models/project_spec.rb:10
```

### Test Database Setup

```bash
# Prepare test database
RAILS_ENV=test rails db:create
RAILS_ENV=test rails db:migrate
```

## API Endpoints

This is an **API-only application** with the following main resources:

### Projects

- `GET /projects` - List all projects
- `GET /projects/:id` - Show project
- `POST /projects` - Create project
- `PATCH/PUT /projects/:id` - Update project
- `DELETE /projects/:id` - Delete project

### Issues (nested under projects)

- `GET /projects/:project_id/issues` - List project issues
- `GET /projects/:project_id/issues/:id` - Show issue
- `POST /projects/:project_id/issues` - Create issue
- `PATCH/PUT /projects/:project_id/issues/:id` - Update issue
- `DELETE /projects/:project_id/issues/:id` - Delete issue

### Comments (nested under issues)

- `GET /issues/:issue_id/comments` - List issue comments
- `GET /issues/:issue_id/comments/:id` - Show comment
- `POST /issues/:issue_id/comments` - Create comment
- `PATCH/PUT /issues/:issue_id/comments/:id` - Update comment
- `DELETE /issues/:issue_id/comments/:id` - Delete comment

## Development

### Code Quality

```bash
# Run RuboCop for code style
bundle exec rubocop

# Run Brakeman for security analysis
bundle exec brakeman
```

### Database Management

```bash
# Reset database
rails db:reset

# Rollback migration
rails db:rollback

# Check migration status
rails db:migrate:status
```

## Deployment

### Production Setup

1. Set production environment variables
2. Configure production database
3. Run migrations: `rails db:migrate RAILS_ENV=production`
4. Precompile assets (if needed): `rails assets:precompile`

### Using Kamal (if configured)

```bash
# Deploy with Kamal
kamal deploy
```

## Configuration

### CORS

CORS is configured to allow all origins for development. For production, update `config/initializers/cors.rb` to restrict origins.

### Database Adapters

- **Development/Test**: PostgreSQL
- **Production**: PostgreSQL (configured via DATABASE_URL)

## Project Structure

```
app/
├── controllers/     # API controllers
├── models/         # ActiveRecord models
└── jobs/           # Background jobs (if any)

spec/
├── controllers/    # Controller specs
├── models/        # Model specs
├── factories/     # FactoryBot factories
└── support/       # Test support files

config/
├── environments/  # Environment-specific configs
├── initializers/ # App initializers
└── routes.rb     # API routes
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Run tests (`bundle exec rspec`)
4. Commit your changes (`git commit -m 'Add amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

## Support

For questions or issues, please create an issue in the repository.

---

**Frontend Repository**: [https://issue-tracking-app-zeta.vercel.app/](https://issue-tracking-app-zeta.vercel.app/)
