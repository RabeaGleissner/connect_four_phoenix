const request = ({
  url,
  requestBody,
  handleResponse,
  setLoading,
  setError,
}: {
  url: string;
  requestBody?: Record<string, any>;
  handleResponse: (data: Record<string, string>) => void;
  setLoading: (state: boolean) => void;
  setError: (state: boolean) => void;
}) => {
  setLoading(true);
  fetch(url, {
    ...(requestBody && {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(requestBody),
    }),
  })
    .then((response) => response.json())
    .then((json) => {
      handleResponse(json.data);
      setLoading(false);
    })
    .catch((error) => {
      console.error(error);
      setError(error);
    });
};

export default request;
