from flask import Flask, render_template, request, jsonify
import random
import string

# Initialize Flask application
app = Flask(__name__)

class PasswordGenerator:
    """Simple password generator"""
    
    def __init__(self):
        self.alphabets = string.ascii_letters
        self.numbers = string.digits
        self.symbols = "!@#$%^&*()_+-=[]{}|;:,.<>?"
    
    def generate_password(self, length, include_alphabets=True, include_numbers=False, include_symbols=False):
        """Generate a random password"""
        
        # Build character set
        character_set = ""
        
        if include_alphabets:
            character_set += self.alphabets
        if include_numbers:
            character_set += self.numbers
        if include_symbols:
            character_set += self.symbols
            
        # Default to alphabets if nothing selected
        if not character_set:
            character_set = self.alphabets
            
        # Generate password
        password = ''.join(random.choice(character_set) for _ in range(length))
        return password

# Create password generator
password_gen = PasswordGenerator()

@app.route('/')
def index():
    """Main page"""
    return render_template('index.html')

@app.route('/generate', methods=['POST'])
def generate_password():
    """Generate password API"""
    try:
        data = request.get_json()
        
        length = int(data.get('length', 12))
        include_alphabets = data.get('alphabets', True)
        include_numbers = data.get('numbers', False) 
        include_symbols = data.get('symbols', False)
        
        # Simple validation
        if length < 4 or length > 50:
            return jsonify({'error': 'Password length must be between 4-50 characters'}), 400
            
        password = password_gen.generate_password(
            length=length,
            include_alphabets=include_alphabets,
            include_numbers=include_numbers,
            include_symbols=include_symbols
        )
        
        return jsonify({'password': password, 'success': True})
        
    except:
        return jsonify({'error': 'Error generating password'}), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)