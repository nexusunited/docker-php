FROM php:7.2-fpm-buster

COPY docker/php/php.ini /usr/local/etc/php/conf.d/docker-php-config.ini

RUN apt-get update && apt-get install -y \
    gnupg \
    g++ \
    procps \
    openssl \
    git \
    unzip \
    zlib1g-dev \
    libzip-dev \
    libfreetype6-dev \
    libpng-dev \
    libjpeg-dev \
    libicu-dev  \
    libonig-dev \
    libxslt1-dev \
    acl \
    libssl-dev \
    bash \
    curl \
    zsh \
    bc \
    wget

RUN pecl install pcov

RUN docker-php-ext-configure gd --with-jpeg --with-freetype \
    docker-php-ext-configure soap --enable-soap \
    && docker-php-ext-install soap pdo pdo_mysql \
    && docker-php-ext-enable pcov

RUN docker-php-ext-install \
    pdo pdo_mysql zip xsl gd intl opcache exif mbstring
    
# Set TIMEZONE
RUN rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && printf '[PHP]\ndate.timezone = "%s"\n', "Europe/Berlin" > /usr/local/etc/php/conf.d/tzone.ini \
    && "date"

RUN wget https://getcomposer.org/composer-1.phar \
 && mv composer-1.phar /usr/local/bin/composer \
 && chmod +x /usr/local/bin/composer \
 && /usr/local/bin/composer global require hirak/prestissimo


WORKDIR /data/
