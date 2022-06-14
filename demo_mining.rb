require 'digest'
require 'pp'
require 'pry'

DEMO_BLOCKCHAIN = [] #grand livre des comptes où on va stocker tous nos blocs
FIRST_TRANSACTION = {from: "Isabelle", to: "Alex", what:"DEMOCOINS", qty: "2"}
DIFFICULTY = "000"

class Block
  attr_reader :index, :nonce, :timestamp, :transaction, :previous_hash, :hash

  def initialize(index, transaction, previous_hash)
    @index         = index
    @timestamp     = Time.now
    @transaction   = transaction
    @previous_hash = previous_hash
    @hash, @nonce  = compute_hash_with_proof_of_work
  end

  def compute_hash_with_proof_of_work(difficulty=DIFFICULTY)
    nonce = 0 #Le nonce permet de faire la proof of work
    loop do 
      hash = compute_hash_with_nonce(nonce)
      if hash.start_with?(difficulty)
        return [hash, nonce]
      else
        nonce += 1
        print "#{nonce} /"
      end
    end
  end

  def compute_hash_with_nonce(nonce = 0)
    sha = Digest::SHA256.new
    sha.update(@index.to_s + nonce.to_s + @timestamp.to_s + @transaction.to_s + @transaction.count.to_s + @previous_hash.to_s)
    sha.hexdigest
  end

end #class Block

# Génération du premier bloc
def create_first_block(first_transaction)
  i = 0
  instance_variable_set("@b#{i}", Block.new(0, first_transaction, "0"))
  DEMO_BLOCKCHAIN << @b0
  pp @b0
end

#Ajout d'un bloc
def add_block
  DEMO_BLOCKCHAIN << Block.new(DEMO_BLOCKCHAIN.last.index + 1, get_transaction,DEMO_BLOCKCHAIN.last.hash)
end

def get_transaction
  transaction_block ||=[]
  blank_transaction = Hash[from: "", to: "", what: "", qty: ""]
  loop do
    puts ""
    puts "Who wants to send DEMOCOINS?"
    from = gets.chomp
    puts ""
    puts "How many DEMOCOINS?"
    qty = gets.chomp
    puts ""
    puts "For who?"
    to = gets.chomp
    what = "DEMOCOINS"

    transaction = Hash[from: "#{from}", to: "#{to}", what: "#{what}", qty: "#{qty}"]
    transaction_block << transaction

    puts ""
    puts "Do you want to do another transaction? (Y/n)"
    new_transaction = gets.chomp.downcase
    
    if new_transaction == "y"
      self
    else
      return transaction_block
    end

  end
end

# create_first_block

def get_hash(data)
    sha = Digest::SHA256.new
    sha.update(data)
    pp sha.hexdigest
end


binding.pry


# create_first_block(FIRST_TRANSACTION)

