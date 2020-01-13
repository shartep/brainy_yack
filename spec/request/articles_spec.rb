require 'rails_helper'

RSpec.describe 'articles', type: :request do
  describe 'GET /articles' do
    subject(:resp) do
      request
      JSON.parse(response.body)
    end

    let(:request) { get '/articles', params: params }
    let(:params) { {} }

    let(:art0_params) { {} }
    let(:art1_params) { {} }
    let(:art2_params) { {} }
    let(:art3_params) { {} }
    let(:art4_params) { {} }
    let(:art5_params) { {} }
    let(:art6_params) { {} }
    let(:art7_params) { {} }
    let(:art8_params) { {} }
    let(:art9_params) { {} }

    let(:article_0) { create_article(created_at: 90.days.ago, updated_at: 68.day.ago, **art0_params) }
    let(:article_1) { create_article(created_at: 80.days.ago, updated_at: 60.day.ago, **art1_params) }
    let(:article_2) { create_article(created_at: 75.days.ago, updated_at: 50.day.ago, **art2_params) }
    let(:article_3) { create_article(created_at: 67.days.ago, updated_at: 44.day.ago, **art3_params) }
    let(:article_4) { create_article(created_at: 50.days.ago, updated_at: 40.day.ago, **art4_params) }
    let(:article_5) { create_article(created_at: 48.days.ago, updated_at: 35.day.ago, **art5_params) }
    let(:article_6) { create_article(created_at: 40.days.ago, updated_at: 22.day.ago, **art6_params) }
    let(:article_7) { create_article(created_at: 30.days.ago, updated_at: 20.day.ago, **art7_params) }
    let(:article_8) { create_article(created_at: 20.days.ago, updated_at: 18.day.ago, **art8_params) }
    let(:article_9) { create_article(created_at: 7.days.ago,  updated_at: 5.day.ago,  **art9_params) }

    before { 10.times { |i| public_send("article_#{i}") } }

    def create_article(created_at: Time.current, updated_at: Time.current, **params)
      Timecop
        .freeze(created_at) { create(:article, params) }
        .tap { |article| Timecop.freeze(updated_at) { article.touch } }
    end

    def serialize_article(article)
      {
        'id' => article.id,
        'story_name' => article.story.name,
        'type' => article.type,
        'name' => article.name,
        'text' => article.text,
        'created_at' => article.created_at.strftime('%F'),
        'updated_at' => article.updated_at.strftime('%F')
      }
    end

    context 'with success status' do
      subject do
        request
        response.status
      end

      it { is_expected.to eq 200 }
    end

    describe 'no filtering and ordering' do
      let(:expected_body) { {
        'articles' => [
          serialize_article(article_0),
          serialize_article(article_1),
          serialize_article(article_2),
          serialize_article(article_3),
          serialize_article(article_4),
          serialize_article(article_5),
          serialize_article(article_6),
          serialize_article(article_7),
          serialize_article(article_8),
          serialize_article(article_9)
        ]
      } }

      it { is_expected.to include(expected_body) }
    end

    describe 'filtered by search term' do
      let(:params) { {search: 'Lorem Ipsum'} }

      let(:art2_params) { {name: 'Lorem Ipsum'} }
      let(:art3_params) { {text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'} }
      let(:art4_params) { {text: 'Text with Lorem ipsum in the middle.'} }

      let(:expected_body) { {
        'articles' => [
          serialize_article(article_2),
          serialize_article(article_3),
          serialize_article(article_4),
        ]
      } }

      it { is_expected.to include(expected_body) }
    end

    describe 'sorted by' do
      let(:params) { { order: {field: field, direction: direction} } }
      let(:field) { :created_at }
      let(:direction) { :asc }

      let(:expected_body) { {
        'articles' => [
          serialize_article(article_1),
          serialize_article(article_4),
          serialize_article(article_7),

          serialize_article(article_0),
          serialize_article(article_2),
          serialize_article(article_5),

          serialize_article(article_3),
          serialize_article(article_6),
          serialize_article(article_8),
          serialize_article(article_9)
        ]
      } }

      describe 'wrong parameter' do
        let(:params) { { order: {field: :title, direction: :up} } }

        context 'with unprocessable status' do
          subject do
            request
            response.status
          end

          it { is_expected.to eq 400 }
        end

        context 'with error message' do
          subject do
            request
            JSON.parse(response.body)
          end

          let(:expected_body) { {
            'status' => 'error',
            'message' => 'Wrong field for order parameter, should be one of story_name, type, name, created_at, updated_at. Or direction parameter, should be one of asc, desc.'
          } }

          it { is_expected.to eq expected_body }
        end
      end

      describe 'story name' do
        let(:field) { :story_name }

        let(:story1) { create(:story, name: 'Big story') }
        let(:story2) { create(:story, name: 'Interesting story') }
        let(:story3) { create(:story, name: 'Victory story') }

        let(:art0_params) { {story: story2} }
        let(:art1_params) { {story: story1} }
        let(:art2_params) { {story: story2} }
        let(:art3_params) { {story: story3} }
        let(:art4_params) { {story: story1} }
        let(:art5_params) { {story: story2} }
        let(:art6_params) { {story: story3} }
        let(:art7_params) { {story: story1} }
        let(:art8_params) { {story: story3} }
        let(:art9_params) { {story: story3} }

        it { is_expected.to include(expected_body) }
      end

      describe 'type' do
        let(:field) { :type }
        let(:direction) { :desc }

        let(:art0_params) { {type: :facebook} }
        let(:art1_params) { {type: :tweet} }
        let(:art2_params) { {type: :facebook} }
        let(:art3_params) { {type: :blog_post} }
        let(:art4_params) { {type: :tweet} }
        let(:art5_params) { {type: :facebook} }
        let(:art6_params) { {type: :blog_post} }
        let(:art7_params) { {type: :tweet} }
        let(:art8_params) { {type: :blog_post} }
        let(:art9_params) { {type: :blog_post} }

        it { is_expected.to include(expected_body) }
      end

      describe 'name' do
        let(:field) { :name }

        let(:art0_params) { {name: 'Dog'} }
        let(:art1_params) { {name: 'Apple'} }
        let(:art2_params) { {name: 'Final'} }
        let(:art3_params) { {name: 'gold'} }
        let(:art4_params) { {name: 'Big'} }
        let(:art5_params) { {name: 'Interesting'} }
        let(:art6_params) { {name: 'human'} }
        let(:art7_params) { {name: 'Cloud'} }
        let(:art8_params) { {name: 'lamp'} }
        let(:art9_params) { {name: 'people'} }

        it { is_expected.to include(expected_body) }
      end

      describe 'created_at' do
        let(:field) { :created_at }
        let(:direction) { :desc }

        let(:expected_body) { {
          'articles' => [
            serialize_article(article_9),
            serialize_article(article_8),
            serialize_article(article_7),
            serialize_article(article_6),
            serialize_article(article_5),
            serialize_article(article_4),
            serialize_article(article_3),
            serialize_article(article_2),
            serialize_article(article_1),
            serialize_article(article_0)
          ]
        } }

        it { is_expected.to include(expected_body) }
      end

      describe 'updated_at' do
        let(:field) { :updated_at }

        let(:expected_body) { {
          'articles' => [
            serialize_article(article_0),
            serialize_article(article_1),
            serialize_article(article_2),
            serialize_article(article_3),
            serialize_article(article_4),
            serialize_article(article_5),
            serialize_article(article_6),
            serialize_article(article_7),
            serialize_article(article_8),
            serialize_article(article_9)
          ]
        } }

        it { is_expected.to include(expected_body) }
      end
    end

    describe 'grouped by' do
      let(:current_time) { Time.new(2019, 12, 11) }

      describe 'wrong parameter' do
        let(:params) { {grouped_by: :title} }

        context 'with unprocessable status' do
          subject do
            request
            response.status
          end

          it { is_expected.to eq 400 }
        end

        context 'with error message' do
          subject do
            request
            JSON.parse(response.body)
          end

          let(:expected_body) { {
            'status' => 'error',
            'message' => 'Wrong grouped_by parameter, should be one of type, name, created_at, updated_at, story'
          } }

          it { is_expected.to eq expected_body }
        end
      end

      describe 'type' do
        let(:params) { { grouped_by: :type } }

        let(:art0_params) { {type: :facebook} }
        let(:art1_params) { {type: :tweet} }
        let(:art2_params) { {type: :facebook} }
        let(:art3_params) { {type: :blog_post} }
        let(:art4_params) { {type: :tweet} }
        let(:art5_params) { {type: :facebook} }
        let(:art6_params) { {type: :blog_post} }
        let(:art7_params) { {type: :tweet} }
        let(:art8_params) { {type: :blog_post} }
        let(:art9_params) { {type: :blog_post} }

        let(:expected_body) { {
          'type' => {
            'blog_post' => [
              serialize_article(article_3),
              serialize_article(article_6),
              serialize_article(article_8),
              serialize_article(article_9)
            ],
            'facebook' => [
              serialize_article(article_0),
              serialize_article(article_2),
              serialize_article(article_5)
            ],
            'tweet' => [
              serialize_article(article_1),
              serialize_article(article_4),
              serialize_article(article_7)
            ]
          }
        } }

        it { is_expected.to include(expected_body) }
      end

      describe 'name' do
        let(:params) { { grouped_by: :name } }

        let(:art0_params) { {name: 'Dog'} }
        let(:art1_params) { {name: 'Interesting'} }
        let(:art2_params) { {name: 'Dog'} }
        let(:art3_params) { {name: 'Apple'} }
        let(:art4_params) { {name: 'Interesting'} }
        let(:art5_params) { {name: 'Dog'} }
        let(:art6_params) { {name: 'Apple'} }
        let(:art7_params) { {name: 'Interesting'} }
        let(:art8_params) { {name: 'Apple'} }
        let(:art9_params) { {name: 'Apple'} }

        let(:expected_body) { {
          'name' => {
            'Apple' => [
              serialize_article(article_3),
              serialize_article(article_6),
              serialize_article(article_8),
              serialize_article(article_9)
            ],
            'Dog' => [
              serialize_article(article_0),
              serialize_article(article_2),
              serialize_article(article_5)
            ],
            'Interesting' => [
              serialize_article(article_1),
              serialize_article(article_4),
              serialize_article(article_7)
            ]
          }
        } }

        it { is_expected.to include(expected_body) }
      end

      describe 'created_at' do
        let(:params) { { grouped_by: :created_at } }

        let(:article_0) { create_article(created_at: current_time - 90.days) }
        let(:article_1) { create_article(created_at: current_time - 90.days) }
        let(:article_2) { create_article(created_at: current_time - 90.days) }
        let(:article_3) { create_article(created_at: current_time - 60.days) }
        let(:article_4) { create_article(created_at: current_time - 60.days) }
        let(:article_5) { create_article(created_at: current_time - 60.days) }
        let(:article_6) { create_article(created_at: current_time - 30.days) }
        let(:article_7) { create_article(created_at: current_time - 30.days) }
        let(:article_8) { create_article(created_at: current_time - 30.days) }
        let(:article_9) { create_article(created_at: current_time - 7.days) }

        let(:expected_body) { {
          'created_at' => {
            '2019-12-03' => [
              serialize_article(article_9)
            ],
            '2019-11-10' => [
              serialize_article(article_6),
              serialize_article(article_7),
              serialize_article(article_8)
            ],
            '2019-10-11' => [
              serialize_article(article_3),
              serialize_article(article_4),
              serialize_article(article_5)
            ],
            '2019-09-11' => [
              serialize_article(article_0),
              serialize_article(article_1),
              serialize_article(article_2)
            ]
          }
        } }

        it { is_expected.to include(expected_body) }
      end

      describe 'updated_at' do
        let(:params) { { grouped_by: :updated_at } }

        let(:article_0) { create_article(created_at: current_time - 90.days, updated_at: current_time - 80.days) }
        let(:article_1) { create_article(created_at: current_time - 90.days, updated_at: current_time - 80.days) }
        let(:article_2) { create_article(created_at: current_time - 90.days, updated_at: current_time - 80.days) }
        let(:article_3) { create_article(created_at: current_time - 60.days, updated_at: current_time - 50.days) }
        let(:article_4) { create_article(created_at: current_time - 60.days, updated_at: current_time - 50.days) }
        let(:article_5) { create_article(created_at: current_time - 60.days, updated_at: current_time - 50.days) }
        let(:article_6) { create_article(created_at: current_time - 30.days, updated_at: current_time - 20.days) }
        let(:article_7) { create_article(created_at: current_time - 30.days, updated_at: current_time - 20.days) }
        let(:article_8) { create_article(created_at: current_time - 30.days, updated_at: current_time - 20.days) }
        let(:article_9) { create_article(created_at: current_time - 7.days, updated_at: current_time - 5.days) }

        let(:expected_body) { {
          'updated_at' => {
            '2019-12-05' => [
              serialize_article(article_9)
            ],
            '2019-11-20' => [
              serialize_article(article_6),
              serialize_article(article_7),
              serialize_article(article_8)
            ],
            '2019-10-21' => [
              serialize_article(article_3),
              serialize_article(article_4),
              serialize_article(article_5)
            ],
            '2019-09-21' => [
              serialize_article(article_0),
              serialize_article(article_1),
              serialize_article(article_2)
            ]
          }
        } }

        it { is_expected.to include(expected_body) }
      end

      describe 'story' do
        let(:params) { { grouped_by: :story } }

        let(:story1) { create(:story, name: 'Big story') }
        let(:story2) { create(:story, name: 'Interesting story') }
        let(:story3) { create(:story, name: 'Victory story') }

        let(:art0_params) { {story: story2, type: :facebook} }
        let(:art1_params) { {story: story1, type: :facebook} }
        let(:art2_params) { {story: story2, type: :blog_post} }
        let(:art3_params) { {story: story3, type: :facebook} }
        let(:art4_params) { {story: story1, type: :blog_post} }
        let(:art5_params) { {story: story2, type: :tweet} }
        let(:art6_params) { {story: story3, type: :blog_post} }
        let(:art7_params) { {story: story1, type: :tweet} }
        let(:art8_params) { {story: story3, type: :tweet} }
        let(:art9_params) { {story: story3, type: :tweet} }

        let(:expected_body) { {
          'story' => {
            'Big story' => {
              'article_count' => 3,
              'article_type_count' => 3,
              'article' => serialize_article(article_7)
            },
            'Interesting story' => {
              'article_count' => 3,
              'article_type_count' => 3,
              'article' => serialize_article(article_5)
            },
            'Victory story' => {
              'article_count' => 4,
              'article_type_count' => 3,
              'article' => serialize_article(article_9)
            }
          }
        } }

        it { is_expected.to include(expected_body) }
      end
    end

    describe 'filtered by search term, sorted by type filed and grouped by story' do
      let(:params) { { search: 'Lorem', order: {field: :type}, grouped_by: :story } }

      let(:story1) { create(:story, name: 'Big story') }
      let(:story2) { create(:story, name: 'Interesting story') }

      let(:art2_params) { {story: story1, name: 'Lorem Ipsum'} }
      let(:art3_params) { {story: story2, text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'} }
      let(:art4_params) { {story: story2, type: article_3.type, text: 'Text with Lorem ipsum in the middle.'} }

      let(:expected_body) { {
        'story' => {
          'Big story' => {
            'article_count' => 1,
            'article_type_count' => 1,
            'article' => serialize_article(article_2)
          },
          'Interesting story' => {
            'article_count' => 2,
            'article_type_count' => 1,
            'article' => serialize_article(article_4)
          }
        }
      } }

      it { is_expected.to include(expected_body) }
    end
  end
end
