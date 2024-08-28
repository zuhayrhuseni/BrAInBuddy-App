# app.py
from flask import Flask, request, jsonify
from textblob import TextBlob
import random

app = Flask(__name__)

# Possible responses categorized by sentiment
positive_responses = [
    "It sounds like you're feeling pretty good! What made you happy today?",
    "That's great to hear! Keep up the positive vibes. Want to share more?",
    "Awesome! Anything special you'd like to talk about?"
]

neutral_responses = [
    "I'm here for you. Want to share more about your day?",
    "Anything on your mind? Feel free to share.",
    "I'm listening. What's happening in your world today?"
]

negative_responses = [
    "I'm sorry to hear that. It's okay to feel this way. What's on your mind?",
    "It sounds like you're going through a tough time. Do you want to talk about it?",
    "I'm here to support you. Would you like some tips or resources to help you through this?"
]

resource_recommendations = [
    "You might find our forum helpful where you can talk to others facing similar challenges.",
    "If you're looking for support, check out our resources page for helpful links and contact information for local therapists.",
    "Remember, it's always okay to reach out for help. Visit our resources page for more information."
]

# Function to select a random response based on sentiment
def get_random_response(sentiment_category):
    if sentiment_category == 'positive':
        return random.choice(positive_responses)
    elif sentiment_category == 'neutral':
        return random.choice(neutral_responses)
    elif sentiment_category == 'negative':
        return random.choice(negative_responses) + " " + random.choice(resource_recommendations)

@app.route('/ai-response', methods=['POST'])
def ai_response_api():
    # Get user input from the JSON request body
    user_input = request.json.get('user_input')
    
    # Perform sentiment analysis using TextBlob
    sentiment = TextBlob(user_input).sentiment
    if sentiment.polarity > 0.2:
        response = get_random_response('positive')
    elif -0.2 <= sentiment.polarity <= 0.2:
        response = get_random_response('neutral')
    else:
        response = get_random_response('negative')
    
    # Check for specific keywords to guide to forums or resources
    keywords_to_forum = ["anxious", "stressed", "overwhelmed", "worried"]
    keywords_to_resources = ["help", "therapist", "counseling", "support"]

    if any(keyword in user_input.lower() for keyword in keywords_to_forum):
        response += " You might find it helpful to join the conversation on our forum."
    elif any(keyword in user_input.lower() for keyword in keywords_to_resources):
        response += " You can check out our resources page for helpful links and contact information."

    # Return the response as JSON
    return jsonify({"response": response})

if __name__ == '__main__':
    app.run(debug=True)