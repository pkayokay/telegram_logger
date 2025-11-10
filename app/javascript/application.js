// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

if (window.Stimulus) {
  Stimulus.handleError = (error, message, detail) => {
    // Log error to console
    console.error(`${message}\n\n`, error, detail);
 
    // Post error to server
    fetch("/errors", {
      method: "POST",
      headers: { 
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({
        title: message,
        details: `${detail.identifier} - ${error.message}`,
      }),
    });
  };
}
