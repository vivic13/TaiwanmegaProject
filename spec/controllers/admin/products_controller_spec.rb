require 'rails_helper'

RSpec.describe Admin::ProductsController, type: :controller do
	include EmailSpec::Helpers
  include EmailSpec::Matchers

	before(:each) do	
    @user = User.create(:email =>"example@gmail.com",:password =>"123456",password_confirmation:"123456" , :role => "admin") 
    @user.confirmed_at = Time.zone.now
    controller.sign_in(@user, scope: :user)
  end

  before(:all) do 
  	DatabaseCleaner.clean
 		@npo = Npo.create(:name => "da")
  	@product_1 = Product.create(npo: @npo, :name => "car",	:rule => "asdfdf", :description => "This is a car",:cost => 2000,:unit => 100, :unit_price => 200,:due_date => "2017-06-20",
 														:cost_detail => "dfdsaf dfe")
  end

  it "user #admin ?" do 
  	 expect(@user).to be_valid
  	 expect(@user.role).to eq("admin")
  end

	it "#index" do 
		get :index
		expect(response).to have_http_status(200)
		expect(response).to render_template(:index)
		expect(Product.count).to eq(1)
	end

	it "#new" do 
		get :new
		expect(response).to have_http_status(200)
		expect(response).to render_template(:new)
	end

	it "#show" do 
		get :show, params: { id: @product_1.id }
		expect(response).to have_http_status(200)
		expect(response).to render_template(:show)
	end

	it "#edit" do 
		get :edit,params: { id: @product_1.id }
		expect(response).to have_http_status(200)
		expect(response).to render_template(:edit)
	end

	
	describe "#create" do
		let(:npo) {FactoryGirl.create(:npo)}
		let(:product) { FactoryGirl.create(:product) }
		it "create record" do 
			expect{post :create, product: FactoryGirl.attributes_for(:product)}.to change(Product,:count).by(1)
			expect(response).to have_http_status(302)
		end

  end


end
