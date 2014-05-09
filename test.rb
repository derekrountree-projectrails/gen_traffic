require "#{Dir::pwd}/support/env"

$biz_names  = []
$search     = {}
$loops      = ENV['loops'] || 20

IO.readlines("search.txt").each do |line|
  geo, term = line.split("> ").collect {|i| i.strip }
  $search[geo] = term
end

def debug
  nil; debugger; nil
end

def click(the_selector, text='')
  if the_selector.is_a?(Capybara::Node::Element)
    the_selector.click
  else
    find(the_selector, :text => text).click
  end
end

def url_encode(val)
  val.gsub(/[,'.]/, '').gsub(/[\s&\/]/, '-').gsub(/-+/, '-').downcase
end

def load_search(city='covina-ca', term='antiques')
  visit("/#{url_encode(city)}/#{url_encode(term)}")
end

def pmp_ad
  attempt, the_link = 0, false
  until the_link do
    candidate = all('.pmp')
    unless candidate.count == 0
      the_link = candidate[rand(candidate.count-1)].find('h3 a')
      puts "[ Using: #{the_link.text} ]"
      $biz_names << the_link.text
      return the_link
    else
      visit current_path
      attempt += 1
      raise "Couldn't find a PMP ad after 10 tries" if attempt >= 10
    end
  end
end

1.upto($loops) do
  $search.each do |geo,term|
    load_search(geo, term)
    click pmp_ad
  end
end