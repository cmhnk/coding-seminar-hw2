def get_guess(trials)
  begin
    current = gets.chomp
    Integer(current)
    current = current.to_i
  rescue ArgumentError, TypeError
      puts 'You didn\'t enter anything...'
      retry
  end
end

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
    winners << {:time => timestamp.inspect, :name => name, :score => (total_guesses.length)}
  end
  puts "~~~~~~~~HIGH SCORES:~~~~~~~~\n\n"
  my_winners = winners.sort_by {|winner| winner[:score]}

  my_winners.each do |winner|
    puts "#{winner[:name]}\t\t\t #{winner[:score]}"
  end
end

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
  trials = 0

  while trials < 3 && feedback.length == 0 do
    current = get_guess(trials)
    total_guesses << current
    trials += 1
    if user_won?(current, computer)
      winner_display(name, total_guesses)
      leaderboard(current, computer, name, total_guesses, winners)
      again?(winners)
    end
    feedback << compare(current, computer)
    informative_guesses << current
  end

  while informative_guesses.length < 2 && feedback.length != 0 do   # was informative_guesses.length
    current = get_guess(trials)
    trials += 1
    total_guesses << current
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
    elsif feedback[-1] == 'L'
      if current > informative_guesses[-1]
        feedback << compare(current, computer)
        informative_guesses << current
      else
        puts 'Dude, pay attention!'
      end
    else
      feedback << compare(current, computer)
    end
  end

  while informative_guesses.length >= 2 && trials < 10 do
    current = get_guess(trials)
    trials += 1
    total_guesses << current
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
    elsif info == 'max, min'
      # normal mode
      if current < informative_guesses[-2] && current > informative_guesses[-1]
        feedback << compare(current, computer)
        informative_guesses << current
      else
        puts 'Are you feeling okay?'
      end
    elsif info == 'min, max'
      if current > informative_guesses[-2] && current < informative_guesses[-1]
        feedback << compare(current, computer)
        informative_guesses << current
      else
        puts 'I feel like you\'re not paying attention...guess again -- and use the hints this time!'
      end
    elsif info == 'max'
      if current < informative_guesses[-1]
        feedback << compare(current, computer)
        informative_guesses << current
      else
        puts 'Don\'t make me be snarky...guess again -- and use the hints this time!'
      end
    end
  end

  if user_won?(current, computer)==FALSE && trials == 10
    puts "\nSorry, the number was #{computer}. You lose. Better luck next time!"
    leaderboard(current, computer, name, total_guesses, winners)
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
