# Run on Heroku using Ruby 1.9.1
require 'sinatra'
require 'action_view'

def load_dictionary(dictionary = "words.txt", max_word_length = 10)
  words = []
  
  File.open(dictionary) do |file|
    file.each do |line| 
      words << line.strip.downcase unless line.length > max_word_length
    end
  end
  
  words.uniq!
end

WORDS = load_dictionary

def generate_password
  password          = ''
  @words_in_password = 4

  (@words_in_password - 1).times do
    password += WORDS.sample + ' ' 
  end

  password + WORDS.sample
end
# FIXME Everything above this line can probably be stored in a class.

before do
  headers "Content-Type" => "text/html; charset=utf-8"
end

get '/' do
  @password       = generate_password
  @words_count   = WORDS.count
  @helper         = Object.new.extend(ActionView::Helpers::NumberHelper)
  @length         = @password.length

  erb :index
end

get '/*' do
  redirect to('/')
end
__END__

@@ layout
<html>
  <head>
    <title><%= @title %></title>
    <style>
      body {
        background-color: #FAFAFA;
        margin:       38px;
      }

      p   {
        padding:        0;
        margin:         0;
        font-family:    Helvetica, Arial, "Lucida Grande", sans-serif;
      }

      a {
        color:            #33C;
        text-decoration:  none;
      }

       a:visited {
        color:            #339;
      }
      
      hr {
        width:            50%;
        height:           1px;
        color:            #999;
        background-color: #999;
        border:           none;
      }

      .one   {
        font-size:    76px;
        line-height:  114px;
        font-weight:  100;
        color:        #111;
      }

      .two   {
        font-size:    47px;
        line-height:  70px;
        font-weight:  300;
        color:        #333;
      }

      .three {
        font-size:    29px;
        line-height:  44px;
        font-weight:  500;
        color:        #555;
      }

      .four  {
        font-size:    18px;
        line-height:  27px;
        font-weight:  700;
        color:        #777;
      }

      .five {
        font-size:    11px;
        line-height:  17px;
        font-weight:  900;
        color:        #999;
      }
    </style>
  </head>
  <body>
    <%= yield %>
  </body>
</html>

@@ index
<% possible_phrases = @words_count**@words_in_password %>
<p class="five">Your new password is:</p>
<p class="one"><%= @password %></p>
<p class="two">There are <%= @words_count %> words in the dictionary.</p>
<p class="three">Thus, there are <%= @helper.number_to_human possible_phrases %> possible passphrases. <span class="four">In security parlance there are <%= possible_phrases.to_s(2).length %> bits of entropy.*</span></p>
<p class="two">So it's probably better than <a href="http://xkcd.com/936/">what you're currently using</a>.</p>
<hr/>
<p class="five">*These bits of entropy are based off of words in the dictionary, not characters in the string. If someone is brute forcing your password with just characters, it will be a lot harder for them.</p>
