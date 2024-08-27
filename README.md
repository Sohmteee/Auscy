# Auscy

Auscy is an open-source chatbot application designed to provide users with a conversational AI experience. It utilizes the Google Gemini API to generate responses and handle various conversational tasks. This project aims to create a versatile and interactive chatbot experience for users.

## Features

- **Chat Interface**: A real-time chat interface where users can interact with the chatbot.
- **Message Handling**: The ability to send and receive text messages.
- **Image Handling**: Support for sending and displaying images within the chat.
- **Chat Naming**: Automatic naming of chats based on conversation history.
- **Chat History**: Persistent storage and retrieval of chat messages.

## Getting Started

To get started with Auscy, follow the instructions below.

### Prerequisites

- Flutter SDK
- Firebase setup
- Google Gemini API key

### Installation

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

4. Set up Firebase and the Google Gemini API:

    - Add your Firebase configuration to `lib/firebase_options.dart`.
    - Add your Google Gemini API key to `.env` in the root of the project. It should look something like:

    ```
    API_KEY=<YOUR-API-KEY>
    ```

5. Run the application:

    ```bash
    flutter run
    ```

## Usage

1. Open the application on your device or emulator.
2. Sign in with your Google account.
3. Start a new chat or continue an existing chat.
4. Send messages and images to interact with the chatbot.

## Contributing

Contributions to Auscy are welcome! If you'd like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch for your changes.
3. Make your changes and test them thoroughly.
4. Submit a pull request describing your changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For questions or support, please contact [your-email@example.com](mailto:your-email@example.com).

---

Thank you for using Auscy! Feel free to explore, contribute, and improve the chatbot application.
