require 'spec_helper'

describe GraphsController do
  context "#national_age_graph" do
    context "for a national_map" do
      before do
        get :national_age_graph, :item_id => 1
      end
      it { should assign_to(:scale_top) }
      it { should assign_to(:ages) }
      it { should render_template(:age) }
    end
  end

  context "#state_age_graph" do
    context "for a state map" do
      before do
        get :state_age_graph, :item_id => 1, :state => 'nc'
      end
      it { should assign_to(:scale_top) }
      it { should assign_to(:ages) }
      it { should render_template(:age) }
    end
  end
end
