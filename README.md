# 🤖 Auscy

Auscy is an open-source chatbot application designed to provide users with a conversational AI experience. It utilizes the Google Gemini API and DeepSeek to generate responses and handle various conversational tasks. This project aims to create a versatile and interactive chatbot experience for users.

<br/>

## 📜 Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [What's New](#whats-new)
- [Upcoming Features](#upcoming-features)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgements](#acknowledgements)
- [Contact](#contact)

<br/>

## ✨ Features

- **Chat Interface**: A real-time chat interface where users can interact with the chatbot.
- **Message Handling**: The ability to send and receive text messages.
- **Image Handling**: Support for sending and displaying images within the chat.
- **Chat Naming**: Automatic naming of chats based on conversation history.
- **Chat History**: Persistent storage and retrieval of chat messages.
- **Voice Recognition**: Transcription of voice messages into text using DeepSeek.
- **Typing Indicator**: Displays when the chatbot is actively generating a response.
- **Custom Message Handling**: Allows handling of specific messages such as images, voice input, and other media.
- **Error Handling**: Provides meaningful error messages for API failures and connectivity issues.
- **Context Awareness**: Generates responses based on the context of the conversation.
- **Light & Dark Mode**: Automatic theme adaptation based on system settings.

<br/>

## 🚀 Getting Started

To get started with Auscy, follow the instructions below.

### 📝 Prerequisites

- Flutter SDK
- Firebase setup
- Google Gemini API key
- DeepSeek API key

<br/>

### 🛠️ Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/sohmteee/auscy.git
   ```

2. Navigate to the project directory:

   ```bash
   cd auscy
   ```

3. Install the dependencies:

   ```bash
   flutter pub get
   ```

4. Set up Firebase, Google Gemini API, and DeepSeek API:

   - Add your Firebase configuration to `lib/firebase_options.dart`.
   - Add your API keys to `.env` in the root of the project. It should look something like:

   ```
   GEMINI_API_KEY=<YOUR-API-KEY>
   DEEPSEEK_API_KEY=<YOUR-API-KEY>
   ```

5. Run the application:

   ```bash
   flutter run
   ```

<br/>

## 💬 Usage

1. Open the application on your device or emulator.
2. Sign in with your Google account.
3. Start a new chat or continue an existing chat.
4. Send messages and images to interact with the chatbot.
5. Use the voice input feature to transcribe spoken words into text.

<br/>

## 💎 What's New

- **Light & Dark Mode**: Added automatic theme switching based on system settings.
- **Enhanced Speech-to-Text**: Accurately convert spoken words into text for seamless hands-free interaction.
- **Context Awareness**: Improved context-aware responses based on conversation history.
- **Error Handling**: Enhanced error handling for API failures and connectivity issues.

<br/>

## 🌀 Upcoming Features

- **Improved Chat UI**: Enhancements to the chat interface for better user experience.
- **Advanced Media Support**: Additional file types supported for sending and receiving.
- **Multilingual Support**: Chatbot responses in multiple languages.

<br/>

## 🤝 Contributing

Contributions to Auscy are welcome! If you'd like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch for your changes.
3. Make your changes and test them thoroughly.
4. Submit a pull request describing your changes.

<br/>

## 📚 License

This project is licensed under the MIT License - see the [LICENSE](https://opensource.org/license/mit) file for details.

<br/>

## 🙏 Acknowledgements

Thanks to Google for providing the [Google Gemini API](https://ai.google.dev/) and DeepSeek for their [transcription services](https://deepseek.com/).

<br/>

## 📧 Contact

For questions or support, please contact [sohmteecodes@gmail.com](mailto:sohmteecodes@gmail.com).

<br/>

Thank you for using Auscy! Feel free to explore, contribute, and improve the chatbot application.
