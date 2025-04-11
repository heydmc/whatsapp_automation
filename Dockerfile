# Use official Python base image
FROM python:3.10-slim

# Install necessary OS packages
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    wget \
    gnupg \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libnspr4 \
    libnss3 \
    libxss1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxtst6 \
    libxrandr2 \
    xdg-utils \
    libu2f-udev \
    libvulkan1 \
    libgbm1 \
    libgtk-3-0 \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app


# Add unzip tool
RUN apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*

COPY . .

# Unzip the wa_profile to use it in headless Chrome
RUN unzip wa_profile.zip -d wa_profile

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Make sure wa_profile directory exists
RUN mkdir -p /app/wa_profile

# Run the bot
CMD ["python", "whatsapp_bot.py"]
