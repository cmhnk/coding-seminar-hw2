def user_won?(current_guess, computer)
  current_guess == computer
end

def winner_display(name, total_guesses)
  puts 'Oh mah gad, that\'s the number I chose! You WIN!'
  puts """
  Adding you to the leaderboard...
  """
end

# array of hashes
def leaderboard(current, computer, name, total_guesses, winners)
  if user_won?(current, computer)
    timestamp = Time.now
    winners << {:name => name, :score => (total_guesses.length + 1), :time => timestamp.inspect}
  end
  puts "~~~~~~~~HIGH SCORES:~~~~~~~~\n\n"
  my_winners = winners.sort_by {|winner| winner[:score]}

  my_winners.each do |winner|
    puts "#{winner[:name]}\t\t\t #{winner[:score]}"
  end
end


#def leaderboard(name)
#  if user_won?(current_guess, computer)
#  puts 'Here is the leaderboard:'
#end

def again?(winners)
  puts 'Would you like to play again? Enter y or n'
  puts '>'
  answer = gets.chomp
  if answer == 'y'
    main(winners)
  elsif answer == 'n'
    'Okay. Exiting game. Goodbye!'
    exit
  else
    puts 'Sorry, I don\'t understand. Exiting game. Goodbye!'
    exit
  end
end



def compare(current, computer)
  #if user_won?(current, computer)
  #  puts 'that\'s the number I picked!! You win!'
  #  exit
  if current > computer
    puts 'too high!'
    feedback = 'H'
  elsif current < computer
    puts 'too low!'
    feedback = 'L'
  end
end


def main(winners)
  puts "Enter your name:"
  name = gets.chomp

  puts "Hello, #{name}. I am choosing a number between 1 and 100..."
  comp_possibilities = (1..100).to_a
  computer = comp_possibilities.sample
  computer = 56

  puts "Okay, guess the number!"

  available_info_hash = {'L' =>{'L' => 'min', 'H' => 'min, max'},
                         'H' => {'L' => 'max, min', 'H' => 'max'}}

  feedback = []
  informative_guesses = []
  total_guesses = []
  trials = 1

  while trials == 1 do
    current = gets.chomp.to_i
    feedback << compare(current, computer)
    if user_won?(current, computer)
      winner_display(name, total_guesses)
      leaderboard(current, computer, name, total_guesses, winners)
      again?(winners)
    end
    informative_guesses << current
    total_guesses << current
    trials += 1
  end

  while informative_guesses.length < 2 do
    current = gets.chomp.to_i
    if user_won?(current, computer)
      winner_display(name, total_guesses)
      leaderboard(current, computer, name, total_guesses, winners)
      again?(winners)
    elsif feedback[-1] == 'H'
      if current < informative_guesses[-1]
        feedback << compare(current, computer)
        informative_guesses << current
      else
        puts 'Way to waste a guess, ya airhead!'
      end
      total_guesses << current
    elsif feedback[-1] == 'L'
      if current > informative_guesses[-1]
        feedback << compare(current, computer)
        informative_guesses << current
      else
        puts 'Um, are you listening??'
      end
      total_guesses << current
    end
    trials += 1
  end

  while informative_guesses.length >= 2 && trials < 11 do
    current = gets.chomp.to_i
    info = available_info_hash[feedback[-2]][feedback[-1]]
    if user_won?(current, computer)
      winner_display(name, total_guesses)
      leaderboard(current, computer, name, total_guesses, winners)
      again?(winners)
    elsif info == 'min'
      # guess should be greater than lower boundary, which is guesses[-1]
      if current > informative_guesses[-1] #normal mode
        feedback << compare(current, computer)
        informative_guesses << current # keep informative guesses separate from total guesses
      elsif current < informative_guesses[-1] #snarky mode
        puts 'helloooooo, you just wasted a guess!'
      end
      total_guesses << current
    elsif info == 'max, min'
      # normal mode
      if current < informative_guesses[-2] && current > informative_guesses[-1]
        feedback << compare(current, computer)
        informative_guesses << current
      else
        puts 'Are you feeling okay?'
      end
      total_guesses << current
    elsif info == 'min, max'
      if current > informative_guesses[-2] && current < informative_guesses[-1]
        feedback << compare(current, computer)
        informative_guesses << current
      else
        puts 'I feel like you\'re not paying attention...guess again -- and use the hints this time!'
      end
      total_guesses << current
    elsif info == 'max'
      if current < informative_guesses[-1]
        feedback << compare(current, computer)
        informative_guesses << current
      else
        puts 'Don\'t make me be snarky...guess again -- and use the hints this time!'
      end
      total_guesses << current
    end
    trials += 1
  end

  if user_won?(current, computer)==FALSE && trials == 11
    puts "\nSorry, the number was #{computer}. You lose. Better luck next time!"
    again?(winners)
  end
end

winners =[]
main(winners)

# current bugs to address:
# trials does not end at 11
# losing doesn't appear to happen
# when 2 high scorers have the same score, defaults to order them by alphabet
# add time instead 
