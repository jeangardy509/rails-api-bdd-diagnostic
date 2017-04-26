# frozen_string_literal: true
require 'rails_helper'

# Instructions:
# The tests you build for this diagnostic are not expected to pass.
# Merely provide a test for each given scenario.

def examples
  Example.all
end

def example
  Example.first
end

#
# Question 1
#
# In a Ruby comment, explain Behavior Driven Development, how it is meant to be
# used, and how it differs from Test Driven Development.
#
# BDD tests from the top down and closely follows a user story. Tests can be written before code is written, or after (backfilling the specs). BDD is based on features. Features are driven by user stories and their acceptance criteria. Feature tests drive unit tests, and unit tests drive code. TDD is bottom up, and tests are written before code. TDD drives implementation of code, and refers to the order of red, green refactor: 1. Write the test, 2. Run the test (it should fail), 3. Write the code, 4. Run the test (if it fails go back to step 3), 5. Refactor, 6. Write the next test.


#
# Question 2
#
# Create a request spec for our Examples API that ensures 'GET /examples'
# responds successfully and lists all examples.

RSpec.describe 'Examples API' do
  # As a user, I want to get all articles

  def examples 
    # could stub Example.all so we don't actually hit db
    Example.all
  end

  it 'lists all examples' do
    get '/examples'
    
    # responds successfully
    expect(response).to be_success 
  
    examples_response = JSON.parse(response.body)
 
    # gets correct data
    expect(response.count).to eq(examples.count)
    expect(examples_response['examples'].first['title']).to eq(example.title)
  end

end

#
# Question 3
#
# Create a routing spec for our `Examples` resource that ensures
# GET /examples/:id routes to the examples#show action.

RSpec.describe 'routes for examples' do
  it 'routes GET /examples/:id to the examples#show action' do
    expect(get('/examples/1')).to route_to(
      controller: 'examples',
      action: 'show',
      id: '1'
    )
  end
end

#
# Question 4
#
# Test that a POST action from our ExamplesController is both successful
# and renders a JSON response.

RSpec.describe ExamplesController do
  def example_params
    {
      name: 'Example name',
      body: 'What a fantastic example this is...'
    }
  end

  describe 'POST create' do
    before(:each) do
      post :create, example: example_params, format: :json
    end

    it 'is successful' do
      expect(response).to be_success
    end

    it 'renders a JSON response' do
      example_response = JSON.parse(response.body)
      expect(example_response).not_to be_nil
    end
  end
end

#
# Question 5
#
# Test that a PATCH action from our ExamplesController is both successful
# and renders a JSON response.

RSpec.describe ExamplesController do
  def example_diff
    {
      body: 'This actually isn\'t that fantastic of an example...'
    }
  end

  describe 'PATCH update' do
    before(:each) do
      patch :update, id: example.id, example: example_diff, format: :json
    end

    it 'is successful' do
      expect(response).to be_success
    end

    it 'renders a JSON response' do
      example_response = JSON.parse(response.body)
      expect(example_response).not_to be_nil
    end
  end
end

#
# Question 6
#
# Test that a DELETE action from our ExamplesController is both successful
# and renders an empty response.

RSpec.describe ExamplesController do
  def example
    Example.first
  end

  describe 'DELETE destroy' do
    before(:each) {
      delete :destroy, id: example.id, format: :json
    }

    it 'is successful' do
      expect(response).to be_success
    end

    it 'returns an empty response body' do
      # use before(:all) so we only delete once and test response object multiple times?
      expect(response.body).to be_empty
    end

  end
end

#
# Question 7
#
# Test that the Example model has an association with an
# `other` model. You'll have to build an `association` model
# on your own.

RSpec.describe Example do
  describe 'associations' do

    def association
      described_class.reflect_on_association(:others)
    end

    it 'has an association with comments' do
      expect(association).to_not be_nil
      expect(association.name).to eq(:comments)
    end
  end
end
