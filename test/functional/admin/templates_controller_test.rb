require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/templates_controller'

# Re-raise errors caught by the controller.
class Admin::TemplatesController; def rescue_action(e) raise e end; end

class Admin::TemplatesControllerTest < Test::Unit::TestCase
  fixtures :attachments, :users, :cached_pages, :sections

  def setup
    prepare_theme_fixtures
    @controller = Admin::TemplatesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as :quentin
  end

  def test_should_show_edit_template_form
    get :edit, :id => attachments(:layout).filename
    assert_tag :tag => 'form'
    assert_tag :tag => 'textarea', :attributes => { :id => 'template_attachment_data' }
  end

  def test_should_require_template_id
    get :edit
    assert_redirected_to :action => 'index'
    assert flash[:error]
    
    get :update
    assert_redirected_to :action => 'index'
    assert flash[:error]
  end

  def test_should_require_posted_template
    get :update, :id => attachments(:layout).filename, :template => { :filename => 'foo' }
    assert_redirected_to :action => 'edit'
    assert flash[:error]
    
    post :update, :id => attachments(:layout).filename
    assert_redirected_to :action => 'edit'
    assert flash[:error]
  end

  def test_should_save_template
    post :update, :id => attachments(:layout).filename, :template => { :filename => 'foo' }
    assert_response :success
    attachments(:layout).reload
    assert_equal 'foo', attachments(:layout).filename
  end
end
