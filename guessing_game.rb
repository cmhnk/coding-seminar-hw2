def user_won?(current_guess, computer)
  current_guess == computer
end

#def leaderboard?
#
#end

def compare(current, computer)
  if user_won?(current, computer)
    puts "that's the number I picked!! You win!"
    exit
  elsif current > computer
    puts "too high!"
    feedback = 'H'
  elsif current < computer
    puts "too low!"
    feedback = 'L'
  end
end

puts "Enter your name:"
name = gets.chomp

puts "Hello, #{name}. I am choosing a number between 1 and 100..."
comp_possibilities = (1..100).to_a
computer = comp_possibilities.sample

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
  informative_guesses << current
  total_guesses << current
  trials += 1
end

while informative_guesses.length < 2 do
  current = gets.chomp.to_i
  if user_won?(current, computer)
    puts "oh mah gad, that's right! you win!"
    exit
  elsif feedback[-1] == 'H'
    if current < informative_guesses[-1]
      feedback << compare(current, computer)
      informative_guesses << current
    else
      puts "Way to waste a guess, ya airhead!"
    end
    total_guesses << current
  elsif feedback[-1] == 'L'
    if current > informative_guesses[-1]
      feedback << compare(current, computer)
      informative_guesses << current
    else
      puts "Um, are you listening??"
    end
    total_guesses << current
  end
  trials += 1
end

while informative_guesses.length >= 2 && trials < 6 do
  current = gets.chomp.to_i
  info = available_info_hash[feedback[-2]][feedback[-1]]
  if user_won?(current, computer)
    puts "you win! good job!"
    exit
  elsif info == 'min'
    # guess should be greater than lower boundary, which is guesses[-1]
    if current > informative_guesses[-1] #normal mode
      feedback << compare(current, computer)
      informative_guesses << current # keep informative guesses separate from total guesses
    elsif current < informative_guesses[-1] #snarky mode
      puts "helloooooo, you just wasted a guess!"
    end
    total_guesses << current
  elsif info == 'max, min'
    # normal mode
    if current < informative_guesses[-2] && current > informative_guesses[-1]
      feedback << compare(current, computer)
      informative_guesses << current
    else
      puts "Are you feeling okay?"
    end
    total_guesses << current
  elsif info == 'min, max'
    if current > informative_guesses[-2] && current < informative_guesses[-1]
      feedback << compare(current, computer)
      informative_guesses << current
    else
      puts "I feel like you're not paying attention...guess again -- and use the hints this time!"
    end
    total_guesses << current
  elsif info == 'max'
    if current < informative_guesses[-1]
      feedback << compare(current, computer)
      informative_guesses << current
    else
      puts "Don't make me be snarky...guess again -- and use the hints this time!"
    end
    total_guesses << current
  end
  trials += 1
end

if user_won?(current, computer)==FALSE && trials == 6
  puts "\nSorry, the number was #{computer}. You lose. Better luck next time!"
end
