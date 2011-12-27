require 'spec_helper'
include VotesToColor

describe 'VotesToColor' do
  context '#votes_to_color' do
    it {votes_to_color(thumbs_up: 10, thumbs_down: 10, neutral: 10, use_default_color: true).should == OURVOYCE_CONFIG['default_graph_color']}
    it {votes_to_color(thumbs_up: 10, thumbs_down: 10, neutral: 10, use_default_color: false).should == OURVOYCE_CONFIG['thumbs_up_color']}

    it {votes_to_color(thumbs_up: 10, thumbs_down: 10, neutral: 10).should == OURVOYCE_CONFIG['thumbs_up_color']}
    it {votes_to_color(thumbs_up: 10, thumbs_down: 9, neutral: 9).should == OURVOYCE_CONFIG['thumbs_up_color']}
    it {votes_to_color(thumbs_up: 10, thumbs_down: 9, neutral: 10).should == OURVOYCE_CONFIG['thumbs_up_color']}
    it {votes_to_color(thumbs_up: 10, thumbs_down: 10, neutral: 9).should == OURVOYCE_CONFIG['thumbs_up_color']}

    it {votes_to_color(thumbs_up: 9, thumbs_down: 10, neutral: 9).should == OURVOYCE_CONFIG['thumbs_down_color']}
    it {votes_to_color(thumbs_up: 9, thumbs_down: 10, neutral: 10).should == OURVOYCE_CONFIG['thumbs_down_color']}

    it {votes_to_color(thumbs_up: 9, thumbs_down: 9, neutral: 10).should == OURVOYCE_CONFIG['neutral_color']}
  end
end

