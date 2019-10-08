module Orders
  class OnOrderAdded
    def call(event)
      puts "\n#{'- -'*20}\n#{event.name}\n#{'- -'*20}\n"
    end
  end
end
