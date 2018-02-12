require 'net/http'
require 'json'
require 'open-uri'

class ExpertsController < ApplicationController
  def index
    @experts = Expert.all
    @friends = Friendship
  end

  def new
  end

  def search_topic(current_expert, term)
    experts = Friendship.where("expert_id = " + params[:id]).all
    found_terms = []

    sep = ""
    experts.each { |expert|
      friend_of_friend = Friendship.where("expert_id = " + expert.friend_id.to_s)

      friend_of_friend.each { |item|
        hits = Topic.select("expert_id, text, INSTR(text, '" + term + "') found")
                    .where("expert_id = " + item.friend_id.to_s + " and found > 0")
        hits.each { |term_found|
          friend_info = Expert.find(expert.friend_id)
          friend_with_term = Expert.find(term_found.expert_id)
          search_path = current_expert.name + ' -> ' + friend_info.name + " -> " + friend_with_term.name
          search_path << ' ("' + term_found.text + '")'
          found_terms.push(search_path)
        }
      }
    }

    return found_terms
  end

  def edit
    friend = Friendship.new
    friend.expert_id = params[:id]
    friend.friend_id = params[:new_friend]
    friend.save
    expert = Expert.find(params[:id])
    redirect_to expert
  end

  def show
    @expert = Expert.find(params[:id])
    if params[:expert] != nil && params[:expert]['term'] != ""
      @term = params[:expert]['term']
      @search_results = search_topic @expert, @term
    end

    @topics = Topic.where(expert_id: params[:id]).order(tag: :asc)
    #@frineds = Friendship.joins(Expert).where(Expert.id = Friendship.expert_id).and(Friendship.expert_id = params[:id])
    @frineds = Expert.distinct.joins("INNER JOIN friendships ON experts.id = friendships.friend_id")
                         .where("friendships.expert_id = " + params[:id])
    #Company.joins(:price_movements,:goods_movements).where("goods_movement.date = price_movement.date")
    @other_experts = Expert.joins("LEFT JOIN friendships ON experts.id = friendships.expert_id")
        #.where("friendships.friend_id !=" + params[:id])
  end

  def create
    new_params = expert_params
    if new_params[:website] != ''
      uri = URI('https://www.googleapis.com/urlshortener/v1/url?key=AIzaSyAbhcPpkrdWTzK3fJSSHZRuguUUMSyJYeA')
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      req = Net::HTTP::Post.new(uri.request_uri, 'Content-Type' => 'application/json')
      req.body = {longUrl: new_params[:website]}.to_json
      short_response = https.request(req)

      if short_response.code == '200'
        short_json = JSON.parse(short_response.body)
        new_params[:short_website] = short_json["id"]
      end
    end

    @expert = Expert.new(new_params)
    get_topics @expert, new_params[:website]

    if @expert.save
      get_topics @expert.id, new_params[:website]
      redirect_to @expert
    else
      render 'new'
    end


  end

  private
  def expert_params
    params.require(:expert).permit(:name, :website)
  end

  private
  def get_topics(expert_id, website)
    topics = open(website).read
    topic_tags = ['h1', 'h2', 'h3']

    topic_tags.each { |tag|
      tag_index = 1
      topic_html = '<' + tag + '>'
      while tag_index != nil
        tag_index = topics.index(/#{topic_html}/i,tag_index+1)
        next if tag_index == nil
        topic_end_html = '</' + tag + '>'
        tag_end_index = topics.index(/#{topic_end_html}/i,tag_index+1)
        if tag_end_index != nil
          topic = Topic.new
          topic.expert_id = expert_id
          topic.tag = tag
          tag_body = tag_index + topic_html.length
          topic.text = topics[tag_body, tag_end_index - tag_body]
          topic.save
        end
      end
    }


  end
end
