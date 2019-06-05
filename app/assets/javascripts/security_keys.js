$(document).ready(function() {

  $('.js-register').click(function() {
    const el = document.querySelector('.js-security-keys');
    if (el && el.dataset.options) {
      const credentialOptions = JSON.parse(el.dataset.options);

      credentialOptions["challenge"] = strToBin(credentialOptions["challenge"]);
      credentialOptions["user"]["id"] = strToBin(credentialOptions["user"]["id"]);

      navigator.credentials.create({ "publicKey": credentialOptions }).then(function(attestation) {
        const data = {
          id: attestation.id,
          response: {
            clientDataJSON: binToStr(attestation.response.clientDataJSON),
            attestationObject: binToStr(attestation.response.attestationObject)
          }
        };

        $('#data').val(JSON.stringify(data));
        $('.js-form').submit();

      }).catch(function(error) {
        console.log(error);
      });
    }
  });
});

function binToStr(bin) {
  return btoa(new Uint8Array(bin).reduce(function (s, byte) {
    return s + String.fromCharCode(byte);
  }, ''));
}

function strToBin(str) {
  return Uint8Array.from(atob(str), function (c) {
    return c.charCodeAt(0);
  });
}
