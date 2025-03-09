class WordsController < ApplicationController
  before_action :set_word, only: %i[ show edit update destroy ]

  # GET /words or /words.json
  def index
    @words = Word.where(used: false)

    # 1. Filter by known pattern (e.g., "s__et")
    if params[:pattern].present?
      pattern = params[:pattern]
      pattern.chars.each_with_index do |letter, index|
        if letter != "_"
          # Filter words to ensure the letter is at the correct index
          @words = @words.where("SUBSTR(word, ?, 1) = ?", index + 1, letter)
        end
      end
    end

    # 2. Filter by included letters (e.g., must include 'A' and 'T')
    if params[:include].present?
      include_letters = params[:include].chars
      include_letters.each do |letter|
        @words = @words.where("word LIKE ?", "%#{letter}%")
      end
    end

    # 3. Filter by excluded letters (e.g., must NOT include 'X' or 'Y')
    if params[:exclude].present?
      exclude_letters = params[:exclude].chars
      exclude_letters.each do |letter|
        @words = @words.where.not("word LIKE ?", "%#{letter}%")
      end
    end

    # 4. Filter by forbidden positions (e.g., 's:1,t:3' means 'S' cannot be at index 1)
    if params[:forbidden].present?
      forbidden_entries = params[:forbidden].split(",") # Split input by commas
      forbidden_entries.each do |entry|
        letter, index = entry.split(":") # Extract letter and index
        index = index.to_i - 1           # Convert 1-based index to 0-based

        # Ensure letter is not at this position
        @words = @words.where.not("SUBSTR(word, ?, 1) = ?", index + 1, letter)
      end
    end
  end
  

  # GET /words/1 or /words/1.json
  def show
  end

  # GET /words/new
  def new
    @word = Word.new
  end

  # GET /words/1/edit
  def edit
  end

  # POST /words or /words.json
  def create
    @word = Word.new(word_params)

    respond_to do |format|
      if @word.save
        format.html { redirect_to @word, notice: "Word was successfully created." }
        format.json { render :show, status: :created, location: @word }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /words/1 or /words/1.json
  def update
    respond_to do |format|
      if @word.update(word_params)
        format.html { redirect_to @word, notice: "Word was successfully updated." }
        format.json { render :show, status: :ok, location: @word }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1 or /words/1.json
  def destroy
    @word.destroy!

    respond_to do |format|
      format.html { redirect_to words_path, status: :see_other, notice: "Word was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def word_params
      params.expect(word: [ :word, :used ])
    end
end
